#!/usr/bin/env rake

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.pattern = 'test/*_test.rb'
end

namespace :db do
  require 'sequel'
  require 'dotenv'
  Dotenv.load
  Sequel.extension :migration
  DB = Sequel.connect(ENV['DATABASE_URL'])

  desc 'Perform migration reset (full erase and migration up)'
  task :reset do
    Sequel::Migrator.run(DB, 'db/migrations', :target => 0)
    Sequel::Migrator.run(DB, 'db/migrations')
    puts '<= sq:migrate:reset executed'
  end

  desc 'Perform migration up to latest migration available'
  task :migrate do
    Sequel::Migrator.run(DB, 'db/migrations')
    puts '<= sq:migrate:up executed'
  end

  desc 'Perform migration down (erase all data)'
  task :down do
    Sequel::Migrator.run(DB, 'db/migrations', :target => 0)
    puts '<= sq:migrate:down executed'
  end
end
