require_relative 'config/environment'

rack = Rack::Builder.new do
  use Rack::CommonLogger
  run Rack::Cascade.new([Rails.application])
end

run rack.to_app
