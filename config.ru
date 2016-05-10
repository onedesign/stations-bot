$stdout.sync = true
ENV['RACK_ENV'] ||= 'development'
require './bootstrap.rb'

class StationsBot::Application < Grape::API
  mount StationsBot::API
  mount StationsBot::OAuth
end
run StationsBot::Application
