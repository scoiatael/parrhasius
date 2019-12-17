# frozen_string_literal: true

desc 'Start dev web server'
task :'dev-webserver' do
  sh 'shotgun serve.rb'
end

desc 'Start dev frontend reloader'
task :'dev-npm-start' do
  Dir.chdir File.expand_path('ext/gallery', __dir__)
  sh 'npm', 'start'
end

desc 'Start pre-compiled server'
task :run do
  ENV['APP_ENV'] = 'production'
  ruby 'serve.rb'
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
  sh 'go build -o ../../lib/parrhasius.so -buildmode=c-shared main.go'
end
