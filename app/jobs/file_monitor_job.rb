require 'iostreams'
require 'net/sftp'

class FileMonitorJob < RocketJob::Job

  self.description         = "File Monitor Job"
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
        if task.files[input.to_s] && task.files[input.to_s][:status] == 'Watching'
          # if the current remote file size matches the last seen size
          if attributes[:size] == task.files[input.to_s][:size]
            task.files[input.to_s][:status] = 'Complete'
            task.files[input.to_s][:last_checked] = Time.now

            
            # processing_job = FileCopyJob.create(
            #   task: task,
            #   matched_file: input.to_s
            # )
            # task.files[input.to_s][:copy_job_id] = processing_job.id.to_s

          else
            # size changed
            task.files[input.to_s] = {
              size: attributes[:size],
              last_checked: Time.now,
              status: 'Watching'
            }
          end
        else
          # Do not replace completed files.
          # Maybe allow replacement after enough time has passed? ex: monthly upload with same file name
          # Or if the file copy job deletes the source on completion that could also work.
          if task.files[input.to_s][:status] != 'Complete'
            # new file seen
            task.files[input.to_s] = {
              size: attributes[:size],
              last_checked: Time.now,
              status: 'Watching'
            }
          end
        end

      end
      task.save
  
      end

  end
end