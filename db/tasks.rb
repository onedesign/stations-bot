#!/usr/bin/env rake

namespace :db do
  require 'sequel'
  require 'dotenv'
  Dotenv.load
  require_relative 'drop.rb'
  require_relative 'create.rb'

  desc 'Connects to database'
  task :connect do
    Sequel.extension :migration
    DB = Sequel.connect(ENV['DATABASE_URL'])
  end

  desc 'Perform migration reset (full drop, complete, and migration up)'
  task :reset do
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:connect"].invoke
    Rake::Task["db:migrate"].invoke
  end

  desc 'Drop database'
  task :drop do
    result = Sequel.drop(ENV['DATABASE_URL'])
    puts "<= #{result}"
  end

  desc 'Creates a database using configuration URL'
  task :create do
    result = Sequel.create(ENV['DATABASE_URL'])
    puts "<= #{result}"
  end

  desc 'Perform migration up to latest migration available'
  task :migrate => :connect do
    Sequel::Migrator.run(DB, 'db/migrations')
    puts '<= db:migrate executed'
  end

  desc 'Perform migration down (erase all data)'
  task :down => :connect do
    Sequel::Migrator.run(DB, 'db/migrations', :target => 0)
    puts '<= db:down executed'
  end
end
