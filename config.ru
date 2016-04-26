ENV['RACK_ENV'] ||= 'development'
require './bootstrap.rb'

run StationsBot::API
run StationsBot::OAuth
