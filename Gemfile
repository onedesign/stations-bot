source 'https://rubygems.org'
# Get the gems compatible for Heroku's Ruby Version 
ruby '2.2.1'
gem 'dotenv'
gem 'rack'
gem 'json'
gem 'grape'
gem 'thin'
gem 'rest-client', '~> 1.8'
gem 'geocoder'
gem 'sequel'

group :production do
  gem 'pg'
end

group :development do
  gem 'mysql2'
end

group :test do
  gem "minitest"
  gem "rack-test", require: "rack/test"
  gem "sqlite3"
end
