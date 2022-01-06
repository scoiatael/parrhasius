require 'rack/cache'
require_relative 'config/environment'
require_relative 'lib/parrhasius'

rack = Rack::Builder.new do
  use Rack::Cache
  use Rack::CommonLogger
  run Rack::Cascade.new([
                          Parrhasius::Application,
                          Rails.application
                        ])
end

run rack.to_app
