module Sequel
  def self.drop(config_uri)
    scheme = URI.parse(ENV['DATABASE_URL']).scheme
    case scheme.to_sym
    when :sqlite
      Sequel::Sqlite::Database.drop(config_uri)
    when :postgres, :pg
      Sequel::Postgres::Database.drop(config_uri)
    when :mysql, :mysql2
      Sequel::Mysql2::Database.drop(config_uri)
    else
      "scheme #{scheme} unsupported for this task"
    end
  end

  module Sqlite
    class Database < Sequel::Database
      def self.drop(config_uri)
        uri = URI.parse(config_uri)
        db_name = File.expand_path('../' + uri.host + uri.path, File.dirname(__FILE__))
        if File.exist?(db_name)
          File.delete(db_name)
          "dropped database #{db_name}"
        else
          "database doesn't exist: #{db_name}"
        end
      end
    end
  end

  module Postgres
    class Database < Sequel::Database
      def self.drop(config_uri)
        uri = URI.parse(config_uri)
        db_name = uri.path[1..-1]
        command = 'dropdb'
        [:user, :password, :host, :port].each do |opt|
          flag = opt == :user ? :username : opt
          value = uri.send(opt)
          command << " --#{flag} #{value}" if value
        end
        command << ' ' + db_name
        if system(command)
          "dropped database #{db_name}"
        else
          "failed to drop database #{db_name}"
        end
      end
    end
  end

  module Mysql2
    class Database < Sequel::Database
      def self.drop(config_uri)
        begin
          db = Sequel.connect(config_uri)
          db_name = db.instance_variable_get(:@opts)[:database]
          db.run("DROP DATABASE IF EXISTS `#{db_name}`;")
          "dropped database #{db_name}"
        rescue Sequel::DatabaseConnectionError
          "database doesn't exist"
        end
      end
    end
  end
end
