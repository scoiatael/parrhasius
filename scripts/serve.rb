# frozen_string_literal: true

require 'sinatra'
require 'rack/cache'

require_relative '../lib/parrhasius/serve'

serve = Parrhasius::Serve.new(File.expand_path(ENV['SERVE'] || './db/staging'))
options = {
  base_path: ''
}

use Rack::Cache

if ENV['APP_ENV'] == 'production'
  set :public_folder, 'ext/gallery/build'

  get '/' do
    redirect '/index.html'
  end
else
  options[:base_path] = 'http://localhost:9393'

  before do
    headers(
      'Access-Control-Allow-Origin' => 'http://localhost:3000'
    )
  end
end

get '/all' do
  data = serve.all
  page = Parrhasius::Serve::Page.new(size: 200, current: Integer(params[:page] || '0'), total: data.size)
  records = data[page.start...page.end]&.map do |t|
    {
      src: options[:base_path] + '/image/' + File.basename(t.path),
      width: t.width,
      height: t.height,
      original: options[:base_path] + '/image_full/' + File.basename(t.path),
      title: File.basename(t.path)
    }
  end
  JSON.dump(
    records: records || [],
    page: page.to_h
  )
end

get '/pages' do
  data = serve.all
  page = Parrhasius::Serve::Page.new(size: 200, current: 0, total: data.size)
  JSON.dump(page.to_h)
end

get '/image_full/:id' do |id|
  cache_control :public
  etag id

  thumbnail = serve.by_basename(id)
  img = serve.full(thumbnail.path)

  content_type img.mime_type
  send_file img.path
end

get '/image/:id' do |id|
  cache_control :public
  etag id

  img = serve.by_basename(id)
  content_type img.mime_type
  send_file img.path
end

options '/image/:id' do
  headers(
    'Access-Control-Allow-Methods' => 'OPTIONS, GET, DELETE'
  )
  status 204
  []
end

delete '/image/:id' do |id|
  serve.delete(id)

  'OK'
end
