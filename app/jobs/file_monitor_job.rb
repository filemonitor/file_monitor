# frozen_string_literal: true

#
# Example:
# FileMonitorJob.create!
#
# Create the scheduled job to run every 5 minutes
# checks Tasks table and transfers the files based on the tasks.

require 'iostreams'
require 'net/sftp'

class FileMonitorJob < RocketJob::Job
  include RocketJob::Plugins::Cron

  self.cron_schedule       = '* * * * * UTC' # TODO: set to run every minute for testing
  self.description         = 'File Monitor Job'
  self.destroy_on_complete = false
  self.collect_output      = false

  def perform
    Task.all.each do |task|
      url  = source_directory(task)
      args = source_credentials(task)

      IOStreams.path(url, args).
        each_child(task.source_pattern, directories: false) do |input, attributes|
        # if the file is already being watched...
        if task.files[input.to_s] && task.files[input.to_s][:status] == 'Watching'
          # if the current remote file size matches the last seen size
          if attributes[:size] == task.files[input.to_s][:size]

            RocketJob::Jobs::CopyFileJob.create!(
              source_url: input.to_s,
              source_args: { username: task.source_username, encrypted_password: task.encrypted_source_password },
              target_url: target_url(task, input),
              target_args: { access_key_id: task.target_username, encrypted_secret_access_key: task.encrypted_target_password }
            )

            task.files[input.to_s][:status]       = 'Complete'
            task.files[input.to_s][:last_checked] = Time.zone.now

            ExampleMailer.sample_email('user').deliver_now
          else
            # size changed
            task.files[input.to_s] = {
              size: attributes[:size],
              last_checked: Time.zone.now,
              status: 'Watching'
            }
          end
        else
          # Do not replace completed files.
          # Maybe allow replacement after enough time has passed? ex: monthly upload with same file name
          # Or if the file copy job deletes the source on completion that could also work.
          if task.files[input.to_s].nil? || task.files[input.to_s][:status] != 'Complete'
            # new file seen
            task.files[input.to_s] = {
              size: attributes[:size],
              last_checked: Time.zone.now,
              status: 'Watching'
            }
          end
        end
      end
      task.save
    end
  end

  def target_url(task, input)
    # "s3://filemonitor/test/test4.csv",
    File.join(
      "#{task.target_protocol&.downcase}://", task.target_host, task.task_name, File.basename(input.to_s)
    )
  end

  def source_directory(task)
    return task.source_host if task.source_protocol == 'FILE'

    File.join("#{task.source_protocol&.downcase}://", task.source_host)
  end

  def source_credentials(task)
    return nil if task.source_protocol == 'FILE'

    {
      username: task.source_username,
      password: task.source_password
    }
  end
end
