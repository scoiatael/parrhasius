# frozen_string_literal: true

require 'sinatra'

require_relative 'folder_server'
require_relative 'image_server'

DIR = File.expand_path(ENV['SERVE'] || './db')
SERVE = Parrhasius::FolderServer.new(DIR)

require 'logger'

logger = Logger.new($stdout)
logger.level = Logger::DEBUG

logger.info "Serving #{DIR}"

module Parrhasius
  class API < Sinatra::Application
    if ENV['APP_ENV'] == 'production'
      set :public_folder, 'ext/gallery/build'
      set :base_path, ''

      get '/' do
        redirect '/index.html'
      end
    else
      set :base_path, 'http://localhost:9393'

      before do
        headers(
          'Access-Control-Allow-Origin' => 'http://localhost:3000'
        )
      end
    end

    get '/bundle/:folder_id' do |folder_id|
      headers(
        'Content-Disposition' => 'attachment'
      )
      content_type 'application/zip'

      src = SERVE.by_id[folder_id]
      t = src.to_archive

      send_file t.path,
                type: 'application/zip',
                disposition: 'attachment',
                filename: File.basename(t.path),
                stream: false
      t.close
      t.unlink
    end

    options '/folder/:folder_id' do
      headers(
        'Access-Control-Allow-Methods' => 'OPTIONS, GET, DELETE'
      )
      status 204
      []
    end

    delete '/folder/:folder_id' do |folder_id|
      src = SERVE.by_id[folder_id]

      src.ids.each do |id|
        thumbnail = src.delete(id)
        SERVE.move_to_bin(thumbnail)
      end

      FileUtils.rm_r(src.dir)
      SERVE.refresh!

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
      src = SERVE.by_id[folder_id]

      dst.join('original').mkpath
      dst.join('thumbnail').mkpath

      src.ids.each do |id|
        src.move(id, dst)
      end

      FileUtils.rm_r(src.dir)
      SERVE.refresh!

      'OK'
    end

    options '/folder/:folder_id/image/:id' do
      headers(
        'Access-Control-Allow-Methods' => 'OPTIONS, GET, DELETE, PUT'
      )
      status 204
      []
    end

    delete '/folder/:folder_id/image/:id' do |folder_id, id|
      thumbnail = SERVE.by_id[folder_id].delete(id)
      SERVE.move_to_bin(thumbnail)

      'OK'
    end

    put '/folder/:folder_id/image/:id' do |folder_id, id|
      SERVE.by_id[folder_id].set(id)

      'OK'
    end
  end
end
