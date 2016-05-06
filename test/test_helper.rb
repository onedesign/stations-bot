ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require 'sequel'

DB = Sequel.sqlite
Sequel.extension :migration
Sequel::Migrator.run(DB, 'db/migrations')

require File.expand_path('../../bootstrap.rb', __FILE__)
require File.expand_path('../stations_bot_test_base.rb', __FILE__)
