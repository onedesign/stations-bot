ENV['RACK_ENV'] = 'test'
require 'rubygems'
require 'minitest/autorun'
require 'rack/test'

require File.expand_path('../../bootstrap.rb', __FILE__)
require File.expand_path('../stations_bot_test_base.rb', __FILE__)

Sequel.extension :migration
Sequel::Migrator.run(DB, 'db/migrations', :target => 0)
Sequel::Migrator.run(DB, 'db/migrations')
