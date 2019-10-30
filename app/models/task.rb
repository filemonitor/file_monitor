class Task
  include Mongoid::Document

  field :task_name,       type: String, default: ""
  field :target_username, type: String, default: ""
  field :target_password, type: String, default: ""
  field :source_username, type: String, default: ""
  field :source_password, type: String, default: ""
  field :source_pattern,  type: String, default: ""

  field :files,           type: Hash, default: {}
end
