# frozen_string_literal: true

# TODO: Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

desc 'Start dev web server'
task :'dev-webserver' do
  sh 'puma', '--bind=tcp://127.0.0.1:9393'
end

desc 'Start dev frontend reloader'
task :'dev-npm-start' do
  Dir.chdir File.expand_path('ext/gallery', __dir__)
  sh 'npm', 'start'
end

desc 'Start pre-compiled server'
task :run do
  ENV['APP_ENV'] = 'production'
  sh 'puma', '--bind=tcp://0.0.0.0:4567', '--workers=4'
end

# Can't multitask because of chdirs inside
desc 'Build assets'
task build: %w[build-gallery compile]

task :'build-gallery' do
  Dir.chdir File.expand_path('ext/gallery', __dir__)
  sh 'npm', 'run', 'build'
end

task :compile do
  Dir.chdir File.expand_path('ext/parrhasius', __dir__)
  ENV.delete('GOPATH')
  sh 'go build -o ../../lib/parrhasius.so -buildmode=c-shared main.go'
end

desc 'Download images from given URLs'
task :download do
  ARGV.shift
  ruby 'scripts/download.rb', *ARGV
  ARGV.each { |a| task(a.to_s) {} }
end

desc 'Merge given wallpaper folders into one'
task :merge do
  ARGV.shift
  ruby 'scripts/merge_into.rb', *ARGV
  ARGV.each { |a| task(a.to_s) {} }
end

desc 'Fix thumbnails in given dir'
task :minify, [:dir] do |_task, args|
  ruby 'scripts/minify.rb', args[:dir]
end
