FactoryBot.define do
  factory :user do
    task_name { 'Task Name' }
    task_host { 'Task Host' }
    target_protocol { 'SFTP' }
    target_format { 'AUTO' }
    target_stream { 'AUTO' }
    target
  end
end