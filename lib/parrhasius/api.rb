# frozen_string_literal: true

require 'sinatra'
require 'base64'

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

    get '/image/:path' do |path|
      cache_control :public
      etag path

      path = File.expand_path(Base64.urlsafe_decode64(path), Parrhasius::DIR)
      return 403 unless path.starts_with?(::Parrhasius::DIR)

      img = MiniMagick::Image.open(path)

      content_type img.mime_type
      send_file img.path
    end
  end
end
