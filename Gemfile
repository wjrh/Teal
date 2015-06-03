source 'https://rubygems.org'
ruby '2.2.0'

gem 'sinatra'
gem 'rake'
gem 'puma' # our web server
gem 'dotenv' # for environment variables
gem 'foreman'
gem 'json'

gem "activerecord" # db
gem "sinatra-activerecord" # db
gem "pg" # db

group :development do
 gem "tux" # for interacting with the app
end

group :test, :development do
  gem 'rspec'
end
 
group :test do
  gem 'rack-test'
  gem 'factory_girl'
  gem 'test-unit'
  gem 'database_cleaner'
end