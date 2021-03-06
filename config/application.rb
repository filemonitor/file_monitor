# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
# require "active_record/railtie"
# require "active_storage/engine"
require 'action_controller/railtie'
require 'action_mailer/railtie'
# require "action_mailbox/engine"
# require "action_text/engine"
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FileMonitor
  class Application < Rails::Application
    if Rails.env.development? || Rails.env.test?
      # Use application config file
      config.secret_config.use :file
    else
      # Read configuration from AWS SSM Parameter Store
      config.secret_config.use :ssm
    end

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # config.filter_parameters += [:password, :password_confirmation]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    #
    config.generators do |g|
      g.orm :mongo_mapper
      g.view_specs false
      g.helper_specs false
    end
  end
end
