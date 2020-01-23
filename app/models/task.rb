# frozen_string_literal: true

class Task
  include Mongoid::Document
  field :task_name,                 type: String, default: ''
  field :target_host,               type: String, default: ''
  field :target_protocol,           type: String, default: 'SFTP'
  field :target_format,             type: String, default: 'AUTO'
  field :target_stream,             type: String, default: 'AUTO'
  field :target_username,           type: String, default: ''
  field :encrypted_target_password, type: String, encrypted: true, default: ''
  field :target_pattern,            type: String, default: ''
  field :source_host,               type: String, default: ''
  field :source_protocol,           type: String, default: 'SFTP'
  field :source_format,             type: String, default: 'AUTO'
  field :source_stream,             type: String, default: 'AUTO'
  field :source_username,           type: String, default: ''
  field :encrypted_source_password, type: String, encrypted: true, default: ''
  field :source_pattern,            type: String, default: ''
  field :files,                     type: Hash,   default: {}

  validates :task_name,
            :target_host,
            :target_protocol,
            :target_format,
            :target_stream,
            :target_username,
            :encrypted_target_password,
            :source_host,
            :source_protocol,
            :source_format,
            :source_stream,
            :source_username,
            :encrypted_source_password, presence: true

  # TODO: I will comment password uniqueness validations for now
  # TODO: because it will not let us to create multiple tasks for the same target/source
  # TODO: and idk if we should be able to do irt, or not
  # validates :encrypted_target_password,
  #           :encrypted_source_password, uniqueness: true
end
