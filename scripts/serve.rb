# frozen_string_literal: true

require 'sinatra'
require 'rack/cache'

require_relative '../lib/parrhasius/folder_server'
require_relative '../lib/parrhasius/image_server'

dir = File.expand_path(ENV['SERVE'] || './db')
serve = Parrhasius::FolderServer.new(dir)
image_servers = Hash.new { |s, folder_id| s[folder_id] = Parrhasius::ImageServer.new(serve.by_id(folder_id)) }
options = {
  base_path: ''
}

require 'logger'

logger = Logger.new(STDOUT)
logger.level = Logger::DEBUG

use Rack::Cache

logger.info "Serving #{dir}"

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
  children = serve.all
  content_type 'application/json'
  JSON.dump(children)
end

get '/folder/:folder_id/all' do |folder_id|
  data = image_servers[folder_id].all
  page = Parrhasius::ImageServer::Page.new(size: 200, current: Integer(params[:page] || '0'), total: data.size)
  records = data[page.start...page.end]&.map do |t|
    {
      src: options[:base_path] + "/folder/#{folder_id}/image/" + File.basename(t.path),
      width: t.width,
      height: t.height,
      original: options[:base_path] + "/folder/#{folder_id}/image_full/" + File.basename(t.path),
      title: File.basename(t.path)
    }
  end
  content_type 'application/json'
  JSON.dump(
    records: records || [],
    page: page.to_h
  )
rescue KeyError => e
  content_type 'application/json'
  status 500
  JSON.dump({
    error: e,
    folder_id: folder_id,
    folder_ids: serve.all.keys
  })
end

get '/folder/:folder_id/image_full/:id' do |folder_id, id|
  cache_control :public
  etag [folder_id, id].join('-')

  thumbnail = image_servers[folder_id].by_basename(id)
  img = image_servers[folder_id].full(thumbnail.path)

  content_type img.mime_type
  send_file img.path
end

get '/folder/:folder_id/image/:id' do |folder_id, id|
  cache_control :public
  etag [folder_id, id].join('-')

  img = image_servers[folder_id].by_basename(id)
  content_type img.mime_type
  send_file img.path
end

options '/folder/:folder_id/image/:id' do
  headers(
    'Access-Control-Allow-Methods' => 'OPTIONS, GET, DELETE, PUT'
  )
  status 204
  []
end

delete '/folder/:folder_id/image/:id' do |folder_id, id|
  thumbnail = image_servers[folder_id].delete(id)
  serve.move_to_bin(thumbnail)

  'OK'
end

put '/folder/:folder_id/image/:id' do |folder_id, id|
  image_servers[folder_id].set(id)

  'OK'
end
