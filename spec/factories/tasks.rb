# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    task_name { 'Test Task' }
    target_host { 'filemonitor' }
    target_pattern { 'test' }
    target_protocol { 'S3' }
    target_format { 'AUTO' }
    target_stream { 'AUTO' }
    target_username { 'target_username' }
    encrypted_target_password { SymmetricEncryption.encrypt('target_password') }
    source_host { 'sftp.release.clarity.net' }
    source_protocol { 'SFTP' }
    source_format { 'AUTO' }
    source_stream { 'AUTO' }
    source_username { 'source_username' }
    encrypted_source_password { SymmetricEncryption.encrypt('source_password') }
    source_pattern { 'test/*' }

    trait :invalid_task do
      task_name { nil }
    end
  end
end
