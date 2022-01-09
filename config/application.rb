require_relative 'boot'

require 'rails/all'
require 'rack/cors'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Parrhasius
  class Application < Rails::Application
    config.active_job.queue_adapter = :sucker_punch
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.logger = Logger.new(STDOUT)

    if ENV['APP_ENV'] != 'production'
      config.middleware.insert_before 0, Rack::Cors do
        allow do
          origins 'http://localhost:3000'
          resource '*', headers: :any, methods: %i[get post patch put]
        end
      end
    end
  end
end
