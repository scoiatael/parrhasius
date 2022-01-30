# frozen_string_literal: true

# TODO: Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

desc 'Start dev web server'
task :'dev-webserver' do
  sh 'guard', '-i'
end

desc 'Start dev frontend reloader'
task :'dev-npm-start' do
  sh 'yarn', 'build', '--watch'
end

desc 'Start pre-compiled server'
task :run do
  ENV['APP_ENV'] = 'production'
  ENV['RAILS_ENV'] = 'production'
  ENV['RAILS_SERVE_STATIC_FILES'] ||= 'true'
  sh 'puma', '--bind=tcp://0.0.0.0:4567', '--workers=4'
end

# Can't multitask because of chdirs inside
desc 'Build assets'
task build: %w[build-gallery compile]

task 'build-gallery': 'assets:precompile'

task :compile do
  Dir.chdir File.expand_path('ext/parrhasius', __dir__)
  ENV.delete('GOPATH')
  sh 'go build -o ../../lib/parrhasius.so -buildmode=c-shared main.go'
end
