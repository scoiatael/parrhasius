# frozen_string_literal: true

require 'sinatra'

require_relative 'lib/parrhasius/serve'

serve = Parrhasius::Serve.new(File.expand_path(ENV['SERVE'] || './db/staging'))
options = {
  base_path: ''
}

if ENV['DEVELOPMENT_HOST']
  options[:base_path] = 'http://localhost:4567'

  before do
    headers(
      'Access-Control-Allow-Origin' => 'http://localhost:3000'
    )
  end
else
  set :public_folder, 'ext/gallery/build'

  get '/' do
    redirect '/index.html'
  end
end

get '/all' do
  JSON.dump(serve.all.map do |t|
              {
                src: options[:base_path] + '/image/' + File.basename(t.path),
                width: t.width,
                height: t.height,
                original: options[:base_path] + '/image_full/' + File.basename(t.path)
              }
            end)
end

get '/image_full/:id' do |id|
  thumbnail = serve.by_basename(id)
  img = serve.full(thumbnail.path)

  content_type img.mime_type
  File.read(img.path)
end

get '/image/:id' do |id|
  img = serve.by_basename(id)
  content_type img.mime_type
  File.read(img.path)
end
