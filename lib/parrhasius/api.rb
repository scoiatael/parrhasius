# frozen_string_literal: true

require 'sinatra'

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
  end
end
