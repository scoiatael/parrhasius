require 'rack/cache'
require_relative 'lib/parrhasius'

rack = Rack::Builder.new do
  use Rack::Cache
  use Rack::CommonLogger
  # use Rails::Rack::Static
  run Rack::Cascade.new([
                          Parrhasius::Application
                          # ActionController::Dispatcher.new
                        ])
end

run rack.to_app
