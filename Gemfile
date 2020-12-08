source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# ruby '2.6.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.3'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# gem 'mysql2"
gem 'mysql2', '>= 0.4.4', '< 0.6.0'
# Gem for yml enviroment variables
gem 'figaro'
# AWS gem
gem "aws-sdk-s3", require: false
# Roles managment gem
gem "rolify"
# Permissions managment
gem 'cancancan'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'
# Api token for auth 
gem 'devise_token_auth'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

#openpay gem
gem 'openpay'

group :production do
  # For AWS
  gem 'unicorn', platforms: :ruby
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # for debugging 
  gem 'pry-rails'
  # for testing
  gem 'rspec-rails', '~> 4.0.1'
  # fake data generators
  gem 'factory_bot_rails', '~> 6.1'
  gem 'faker', '~> 2.13'
end

group :test do 
  # Matchers for testing
  gem 'shoulda-matchers', '~> 4.0'
  # Clean database for each unit and feature test
  gem 'database_cleaner', '~> 1.8', '>= 1.8.5'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
