# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false
gem 'bson_ext'
gem 'devise'
gem 'mongoid'
gem 'secret_config'
# Encryption
gem 'symmetric-encryption', '~> 4.1'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rubocop', '~> 0.77.0', require: false
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  # There may be other lines in this block already. Simply append the following after:
  %w[rspec-core rspec-expectations rspec-mocks rspec-support].each do |lib|
    gem lib, git: "https://github.com/rspec/#{lib}.git", branch: 'master'
  end
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
  gem 'rspec-rails', git: 'https://github.com/rspec/rspec-rails', branch: '4-0-maintenance' # Previously '4-0-dev' branch
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# UI gems
gem 'bootstrap-table-rails'
gem 'jquery-rails'
gem 'simple_form'

# File storage
gem 'aws-sdk-s3', '~> 1.43'
gem 'iostreams', git: 'https://github.com/rocketjob/iostreams.git'

# RocketJob gems
# gem 'iostreams', git: 'https://github.com/marc/iostreams'
gem 'net-sftp'
gem 'rails_semantic_logger'
gem 'rocketjob', '~> 5.0.0.beta4'
gem 'rocketjob_mission_control'

gem 'letter_opener'
