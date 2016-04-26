ENV['RACK_ENV'] = 'test'
require 'rubygems'
require 'minitest/autorun'
require 'rack/test'

File.delete('test/stations_bot-test.db')

require File.expand_path('../../bootstrap.rb', __FILE__)
require File.expand_path('../stations_bot_test_base.rb', __FILE__)

Sequel.extension :migration
Sequel::Migrator.run(DB, 'db/migrations')
