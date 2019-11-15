FactoryBot.define do
  factory :task do
    task_name { 'Task Name' }
    target_host { 'Target Host' }
    target_protocol { 'SFTP' }
    target_format { 'AUTO' }
    target_stream { 'AUTO' }
    target_username { 'Target Username' }
    target_password { 'Target Password' }
    source_host { 'Source Host' }
    source_protocol { 'SFTP' }
    source_format { 'AUTO' }
    source_stream { 'AUTO' }
    source_username { 'Source Username' }
    source_password { 'Source Password' }
  end

  factory :invalid_task do
    task_name nil
  end
end