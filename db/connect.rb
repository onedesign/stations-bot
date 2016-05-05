require 'sequel'
case ENV['RACK_ENV'].to_sym
  when :test
    DB = Sequel.connect('sqlite://test/stations_bot-test.db')
  when :development, :production
    DB = Sequel.connect(ENV['DATABASE_URL'])
  else
end
