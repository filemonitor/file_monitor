class Task
  include Mongoid::Document
  field :task_name,          type: String, default: ""
  field :task_host,          type: String, default: ""
  field :target_protocol,        type: String, default: "SFTP"
  field :target_format,      type: String, default: "AUTO"
  field :target_stream,      type: String, default: "AUTO"
  field :target_username,    type: String, default: ""
  field :target_password,    type: String, default: ""
  field :source_host,          type: String, default: ""
  field :source_protocol,        type: String, default: "SFTP"
  field :source_format,      type: String, default: "AUTO"
  field :source_stream,      type: String, default: "AUTO"
  field :source_username,    type: String, default: ""
  field :source_password,    type: String, default: ""
  field :source_pattern,     type: String, default: ""
  field :files,              type: Hash, default: {}
end
