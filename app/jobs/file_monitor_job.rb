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
      url         = source_directory(task)
      source_args = source_credentials(task)
      target_args = target_credentials(task)

      IOStreams.path(url, source_args).
        each_child(task.source_pattern, directories: false) do |input, attributes|

        # if the file is already being watched...
        if task.files[input.to_s] && task.files[input.to_s][:status] == 'Watching'
          # if the current remote file size matches the last seen size
          if attributes[:size] == task.files[input.to_s][:size]

            RocketJob::Jobs::CopyFileJob.create!(
              source_url:  input.to_s,
              source_args: source_args,
              target_url:  target_url(task, input),
              target_args: target_args
            )

            task.files[input.to_s][:status]       = 'Complete'
            task.files[input.to_s][:last_checked] = Time.zone.now

            ExampleMailer.sample_email('user').deliver_now
          else
            # size changed
            task.files[input.to_s] = {
              size:         attributes[:size],
              last_checked: Time.zone.now,
              status:       'Watching'
            }
          end
        else
          # Do not replace completed files.
          # Maybe allow replacement after enough time has passed? ex: monthly upload with same file name
          # Or if the file copy job deletes the source on completion that could also work.
          if task.files[input.to_s].nil? || task.files[input.to_s][:status] != 'Complete'
            # new file seen
            task.files[input.to_s] = {
              size:         attributes[:size],
              last_checked: Time.zone.now,
              status:       'Watching'
            }
          end
        end
      end
      task.save
    end
  end

  def target_url(task, input)
    File.join(
      "#{task.target_protocol&.downcase}://", task.target_host, task.target_pattern, File.basename(input.to_s)
    )
  end

  def source_directory(task)
    return task.source_host if task.source_protocol == 'FILE'

    File.join("#{task.source_protocol&.downcase}://", task.source_host)
  end

  def source_credentials(task)
    args = {}

    return nil if task.source_protocol == 'FILE'

    if task.source_protocol == 'SFTP'
      args = {
        username:    task.source_username,
        password:    task.source_password,
      }
    elsif task.source_protocol == 'S3'
      args = {
        access_key_id:     task.source_username,
        secret_access_key: task.source_password
      }
    end
    args
  end

  def target_credentials(task)
    args = {}

    return nil if task.target_protocol == 'FILE'

    if task.target_protocol == 'SFTP'
      args = {
        username:    task.target_username,
        password:    task.target_password,
      }
    elsif task.target_protocol == 'S3'
      args = {
        access_key_id:     task.target_username,
        secret_access_key: task.target_password
      }
    end
    args
  end
end
