# frozen_string_literal: true

require 'iostreams'
require 'net/sftp'

class FileCopyJob < RocketJob::Job
  self.description         = 'File Copy Job'
  self.destroy_on_complete = false
  self.collect_output      = false

  field :task, type: Hash, user_editable: false
  field :source_username, type: String, user_editable: false
  field :source_password, type: String, user_editable: false
  field :source_hostname, type: String, user_editable: false

  field :target_username, type: String, user_editable: false
  field :target_password, type: String, user_editable: false
  field :target_hostname, type: String, user_editable: false

  def perform; end
end
