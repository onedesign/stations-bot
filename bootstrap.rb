require 'rubygems'
require 'dotenv'
Dotenv.load
require 'grape'
require 'json'
require 'rest-client'
require 'geocoder'

Dir["./lib/*.rb"].each {|file| require file }
Dir["./app/commands/*.rb"].each {|file| require file }

require './stations_bot.rb'
