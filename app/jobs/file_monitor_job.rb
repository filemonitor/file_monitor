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

  # From `man ssh_config`:
  # StrictHostKeyChecking
  # If this flag is set to yes, ssh(1) will never automatically add host keys to the ~/.ssh/known_hosts file, and refuses to connect to hosts whose host key has changed.  This provides maximum protection
  # against man-in-the-middle (MITM) attacks, though it can be annoying when the /etc/ssh/ssh_known_hosts file is poorly maintained or when connections to new hosts are frequently made.  This option
  # forces the user to manually add all
  # If this flag is set to ``accept-new'' then ssh will automatically add new host keys to the user known hosts files, but will not permit connections to hosts with changed host keys.  If this flag is set
  # to ``no'' or ``off'', ssh will automatically add new host keys to the user known hosts files and allow connections to hosts with changed hostkeys to proceed, subject to some restrictions.  If this
  # flag is set to ask (the default), new host keys will be added to the user known host files only after the user has confirmed that is what they really want to do, and ssh will refuse to connect to
  # hosts whose host key has changed.  The host keys of known hosts will be verified automatically in all cases.
  # TODO: I set it to 'no' for development ease, will need to discuss and change later on.

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
              source_args: {
                username: task.source_username,
                encrypted_password: task.encrypted_source_password,
                ssh_options: {
                  StrictHostKeyChecking: 'no'
                }
              },
              target_url: target_url(task, input),
              target_args: {
                access_key_id: task.target_username,
                encrypted_secret_access_key: task.encrypted_target_password
              }
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
    # TODO: think about switching to IOStreams.path
    File.join(
      "#{task.target_protocol&.downcase}://", task.target_host, task.target_pattern, File.basename(input.to_s)
    ).to_s
  end

  def source_directory(task)
    return task.source_host if task.source_protocol == 'FILE'

    # TODO: think about switching to IOStreams.path
    File.join("#{task.source_protocol&.downcase}://", task.source_host).to_s
  end

  def source_credentials(task)
    return nil if task.source_protocol == 'FILE'

    {
      username: task.source_username,
      password: task.source_password
    }
  end
end
