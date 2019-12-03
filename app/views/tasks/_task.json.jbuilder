# frozen_string_literal: true

json.extract! task, :id, :task_name, :target_username, :target_password, :source_username, :source_password, :source_pattern, :created_at, :updated_at
json.url task_url(task, format: :json)
