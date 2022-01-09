# frozen_string_literal: true

source 'https://rubygems.org'

# core
gem 'concurrent-ruby'
gem 'down'
gem 'faraday'
gem 'faraday-cookie_jar'
gem 'faraday_middleware'
gem 'ffi'
gem 'mini_magick'
gem 'nokogiri'
gem 'ruby-progressbar'
gem 'rubyzip'
gem 'sinatra'

# webserver
gem 'puma'
gem 'rack-cache'

group :development do
  gem 'guard'
  gem 'guard-rack'
  gem 'pry-byebug'
  gem 'rack-cors'
  gem 'rake'
  gem 'rubocop'
  gem 'shotgun'
  gem 'solargraph'
end

# RAILS
gem 'jbuilder'
gem 'rails', '~> 7.0.0'
gem 'sqlite3', '~> 1.4'

# https://github.com/brandonhilkert/sucker_punch#active-job
gem 'sucker_punch'

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

gem 'bootsnap', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem "rack-cors"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end
