# frozen_string_literal: true

require 'sinatra'
require 'base64'

module Parrhasius
  class API < Sinatra::Application # rubocop:todo Style/Documentation
    get '/image/:path' do |path|
      cache_control :public
      etag path

      path = File.expand_path(Base64.urlsafe_decode64(path), Parrhasius::DIR)
      return 403 unless path.starts_with?(::Parrhasius::DIR)

      send_file path
    end
  end
end
