require 'rubygems'
require 'dotenv'
Dotenv.load
require 'grape'
require 'json'
require 'rest-client'
require 'geocoder'
require File.expand_path('../db/connect.rb', __FILE__)

Dir["./lib/*.rb"].each {|file| require file }
Dir["./app/commands/*.rb"].each {|file| require file }

require './stations_bot.rb'
