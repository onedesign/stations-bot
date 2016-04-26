require 'sequel'
case ENV['RACK_ENV'].to_sym
  when :test
    require 'sqlite3'
    DB = Sequel.connect('sqlite://test/stations_bot-test.db')
  when :development
    require 'mysql2'
    DB = Sequel.connect(ENV['DATABASE_URL'])
  else
    require 'pg'
    DB = Sequel.connect(ENV['DATABASE_URL'])
end
