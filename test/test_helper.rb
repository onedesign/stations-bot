ENV['RACK_ENV'] = 'test'
require 'rubygems'
require 'minitest/autorun'
require 'rack/test'

require 'sequel'
File.delete('test/stations_bot-test.db') if File.exist?('test/stations_bot-test.rb')
require File.expand_path('../../db/connect.rb', __FILE__)
Sequel.extension :migration
Sequel::Migrator.run(DB, 'db/migrations')

require File.expand_path('../../bootstrap.rb', __FILE__)
require File.expand_path('../stations_bot_test_base.rb', __FILE__)
