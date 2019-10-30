require 'iostreams'
require 'net/sftp'

class FileMonitorJob < RocketJob::Job

  self.description         = "STS File Monitor"
  self.destroy_on_complete = false
  self.collect_output      = false

  def perform

    Task.all.each do |task|

      puts task.inspect
      url = "sftp://#{task.task_name}"
      puts url
      IOStreams.
      path(url, username: task.source_username, password: task.source_password).
      each_child(task.source_pattern, directories: false) do |input,attributes|

        # if the file is already being watched...
        # TODO ignore watched files that are too far in the past
        if task.files[input.to_s] && task.files[input.to_s][:status] == 'Watching'
          # if the current remote file size matches the last seen size
          if attributes[:size] == task.files[input.to_s][:size]
            task.files[input.to_s][:status] = 'Complete'
            task.files[input.to_s][:last_checked] = Time.now

            # processing_job = FileCopyJob.new(
            #   task: task,
            #   matched_file: input.to_s
            # )

          else
            # size changed
            task.files[input.to_s] = {
              size: attributes[:size],
              last_checked: Time.now,
              status: 'Watching'
            }
          end
        else
          # new file seen
          task.files[input.to_s] = {
            size: attributes[:size],
            last_checked: Time.now,
            status: 'Watching'
          }
        end

      end
      task.save
  
      end

  end
end