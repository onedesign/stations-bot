require 'rubygems'
require 'dotenv'
Dotenv.load
require 'grape'
require 'json'
require 'rest-client'
require 'geocoder'
require 'sequel'
DB = Sequel.connect(ENV['DATABASE_URL']) unless defined? DB

Dir["./lib/*.rb"].each {|file| require file }
Dir["./app/commands/*.rb"].sort.each {|file| require file }
Dir["./app/models/*.rb"].each {|file| require file }

require './stations_bot.rb'
require './oauth.rb'
