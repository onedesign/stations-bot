module Sequel
  def self.create(config_uri)
    scheme = URI.parse(config_uri).scheme
    case scheme.to_sym
    when :sqlite
      Sequel::Sqlite::Database.create(config_uri)
    when :pg, :postgres
      Sequel::Postgres::Database.create(config_uri)
    when :mysql, :mysql2
      Sequel::Mysql2::Database.create(config_uri)
    else
      "scheme #{scheme} unsupported for this task"
    end
  end

  module Sqlite
    class Database < Sequel::Database
      def self.create(config_uri)
        # call anything on the DB connection to save it
        Sequel.connect(config_uri).tables
        uri = URI.parse(config_uri)
        "created database #{uri.host + uri.path}"
      end
    end
  end

  module Postgres
    class Database < Sequel::Database
      def self.create(config_uri)
        uri = URI.parse(config_uri)
        db_name = uri.path[1..-1]
        command = 'createdb'
        [:user, :password, :host, :port].each do |opt|
          flag = opt == :user ? :username : opt
          value = uri.send(opt)
          command << " --#{flag} #{value}" if value
        end
        command << ' ' + db_name
        if system(command)
          "created database #{db_name}"
        else
          "failed to create database #{db_name}"
        end
      end
    end
  end

  module Mysql2
    class Database < Sequel::Database
      def self.create(config_uri)
        uri = URI.parse(config_uri)
        client = Sequel::Database.adapter_class(uri.scheme)
        uri_options = client.send(:uri_to_options, uri)
        database_name = uri_options.delete(:database)
        db = client.new(uri_options)
        db.run("CREATE DATABASE IF NOT EXISTS `#{database_name}`;")
        "created database #{database_name}"
      end
    end
  end
end
