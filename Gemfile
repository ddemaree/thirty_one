# A sample Gemfile
source "http://rubygems.org"

gem 'activerecord', '~> 3.1'
gem 'activesupport', '~> 3.1'
gem 'sinatra'
gem 'sprockets', '~> 2.0'
gem 'sass', '~> 3.1'
gem 'coffee-script'

group :development do
  gem 'heroku'
  gem 'shotgun'
end

group :development, :test do
  gem 'sqlite3'
  gem 'rspec'
  gem 'rack-test', "~> 0.5.7"
end

group :production do
  gem 'pg'
  gem 'thin'
end