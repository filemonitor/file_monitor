# frozen_string_literal: true

module Admin
  class MonitorController < ApplicationController
    skip_before_action :authenticate_user!

    def health_check
      # Ensure the Mongo connection is active
      User.count
      render body: "FileMonitor is alive at #{Time.current} from #{`hostname`.strip}."
    end
  end
end
