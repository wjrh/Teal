source 'https://rubygems.org'
ruby '2.2.2'

gem 'sinatra'
gem 'rake'
gem 'puma' # our web server
gem 'foreman'

gem 'json'
gem 'multi_json'

gem "sinatra-activerecord" # db
gem "pg" # db

group :development, :test do
	gem 'dotenv' # for environment variables
	gem 'rspec'
end

group :test do
	gem 'rack-test'
	gem 'factory_girl'
	gem 'test-unit'
	gem 'database_cleaner'
end