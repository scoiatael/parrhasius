# frozen_string_literal: true

require 'sinatra'
configure { set :server, :puma }
require 'rack/cache'

require_relative '../lib/parrhasius'
require_relative '../lib/parrhasius/folder_server'
require_relative '../lib/parrhasius/image_server'

dir = File.expand_path(ENV['SERVE'] || './db')
serve = Parrhasius::FolderServer.new(dir)
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

def src_url(base_path, folder_id, img)
  base_path + "/folder/#{folder_id}/image/" + File.basename(img.path) unless img.nil?
end

get '/all' do
  children = serve.all.map { |k, v| [k, {name: v, avatar: src_url(options[:base_path], k, serve.by_id[k].first)}]} .to_h
  content_type 'application/json'
  JSON.dump(children)
end

get '/bundle/:folder_id' do |folder_id|
  headers(
    'Content-Disposition' => 'attachment',
  )
  content_type 'application/zip'

  src = serve.by_id[folder_id]
  t = src.to_archive

  send_file t.path,
            :type => 'application/zip',
            :disposition => 'attachment',
            :filename => File.basename(t.path),
            :stream => false
  t.close
  t.unlink
end

get '/folder/:folder_id' do |folder_id|
  data = serve.by_id[folder_id].all
  page = Parrhasius::ImageServer::Page.new(size: 200, current: Integer(params[:page] || '0'), total: data.size)
  records = data[page.start...page.end]&.map do |t|
    {
      src: src_url(options[:base_path], folder_id, t),
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

options '/folder/:folder_id' do
  headers(
    'Access-Control-Allow-Methods' => 'OPTIONS, GET, DELETE'
  )
  status 204
  []
end

delete '/folder/:folder_id' do |folder_id|
  src = serve.by_id[folder_id]

  src.ids.each do |id| 
    thumbnail = src.delete(id)
    serve.move_to_bin(thumbnail)
  end

  FileUtils.rm_r(src.dir)
  serve.refresh!

  'OK'
end

options '/folder/:folder_id/merge' do
  headers(
    'Access-Control-Allow-Methods' => 'POST'
  )
  status 204
  []
end

post '/folder/:folder_id/merge' do |folder_id|
  payload = JSON.parse(request.body.read)
  target = payload.fetch('target')

  logger.info "Received merge request #{payload}"

  dst = Pathname.new(dir).join(target)
  src = serve.by_id[folder_id]

  dst.join('original').mkpath
  dst.join('thumbnail').mkpath

  src.ids.each do |id| 
    src.move(id, dst)
  end

  FileUtils.rm_r(src.dir)
  serve.refresh!

  'OK'
end

get '/folder/:folder_id/image_full/:id' do |folder_id, id|
  cache_control :public
  etag [folder_id, id].join('-')

  thumbnail = serve.by_id[folder_id].by_basename(id)
  img = serve.by_id[folder_id].full(thumbnail.path)

  content_type img.mime_type
  send_file img.path
end

get '/folder/:folder_id/image/:id' do |folder_id, id|
  cache_control :public
  etag [folder_id, id].join('-')

  img = serve.by_id[folder_id].by_basename(id)
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
  thumbnail = serve.by_id[folder_id].delete(id)
  serve.move_to_bin(thumbnail)

  'OK'
end

put '/folder/:folder_id/image/:id' do |folder_id, id|
  serve.by_id[folder_id].set(id)

  'OK'
end

options '/downloads' do
  headers(
    'Access-Control-Allow-Methods' => 'OPTIONS, GET, POST',
    'Access-Control-Allow-Headers' => 'Content-Type, Content-Length'
  )
  status 204
  []
end

class StreamingProgressBar
  def initialize(stage, stream)
    @stage = stage
    @stream = stream
    @title = nil
    @total = nil
    @progress = nil
  end

  def create(title:, total:, format:)
    @title = title
    @total = total
    @progress = 0
    out(:start)
    self
  end

  def increment
    @progress += 1
    out(:increment)
  end

  def finish
    out(:done)
  end

  private

  def out(status)
    @stream << JSON.dump(stage: @stage, status: status, progress: @progress, total: @total, title: @title) + ','
  end
end

post '/downloads' do 
  payload = JSON.parse(request.body.read)
  url = payload.fetch('url')

  logger.info "Received download request #{payload}"

  stream do |out|
    out << '{ "events":['
    storage = Parrhasius::Storage.new([dir, Time.now.to_i, 'original'].join('/'))
    download_pb = StreamingProgressBar.new(:downloading, out)
    Parrhasius::Download.new(Parrhasius::Download.for(url), storage, download_pb).run(url)
    dedup_pb = StreamingProgressBar.new(:deduping, out)
    Parrhasius::Dedup.new(db: "#{dir}/index.pstore", dir: storage.dir, progress_bar: dedup_pb).run
    minify_pb = StreamingProgressBar.new(:minifying, out)
    Parrhasius::Minify.new(minify_pb).run(src: storage.dir, dest: storage.dir.sub('original', 'thumbnail'))
    serve.refresh!
    out << JSON.dump(done: true) + ']}'
  end
end
