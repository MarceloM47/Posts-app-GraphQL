require_relative "boot"

require "rails/all"
require "sprockets/railtie"

# Require the gems listed in Gemfile
Bundler.require(*Rails.groups)

module GraphpQlCrud
  class Application < Rails::Application
    # Initialize configuration defaults
    config.load_defaults 7.2

    # API only config
    config.api_only = true

    # GraphiQL config for development
    unless Rails.env.production?
      config.session_store :cookie_store, key: '_graphql_session'
      config.middleware.use ActionDispatch::Cookies
      config.middleware.use config.session_store
    end
  end
end
