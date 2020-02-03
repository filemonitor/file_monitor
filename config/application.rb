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

    # Rocket Job
    config.rocket_job.include_filter    = config.secret_config['rocket_job/include_filter']
    config.rocket_job.exclude_filter    = config.secret_config['rocket_job/exclude_filter']
    config.rocket_job.where_filter      = config.secret_config.fetch('rocket_job/where_filter', type: :json, default: nil)
    config.rocket_job.max_workers       = config.secret_config.fetch('rocket_job/max_workers', type: :integer, default: 10)
    config.rocket_job.heartbeat_seconds = config.secret_config.fetch('rocket_job/heartbeat_seconds', type: :float, default: 15.0)
    config.rocket_job.max_poll_seconds  = config.secret_config.fetch('rocket_job/max_poll_seconds', type: :float, default: 5.0)
    config.rocket_job.re_check_seconds  = config.secret_config.fetch('rocket_job/re_check_seconds', type: :float, default: 60.0)

    # Logging
    config.log_level                       = config.secret_config.fetch('logger/level', default: :info, type: :symbol)
    config.semantic_logger.backtrace_level = config.secret_config.fetch('logger/backtrace_level', default: :error, type: :symbol)
    config.semantic_logger.application     = config.secret_config.fetch('logger/application', default: 'file-monitor')
    config.semantic_logger.environment     = config.secret_config.fetch('logger/environment', default: Rails.env)

    destination = config.secret_config.fetch('logger/destination', default: :file, type: :symbol)
    if destination == :stdout
      STDOUT.sync                                    = true
      config.rails_semantic_logger.add_file_appender = false
      config.semantic_logger.add_appender(
        io: STDOUT,
        level: config.log_level,
        formatter: config.secret_config.fetch('logger/formatter', default: :default, type: :symbol)
      )
    end
    config.rails_semantic_logger.ap_options = { ruby19_syntax: true, multiline: false }

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
