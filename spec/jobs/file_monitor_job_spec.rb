# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FileMonitorJob, type: :job do
  let (:job) { described_class.new }

  describe 'target_url' do
    let (:task) { create(:task) }

    describe 'S3 protocol' do
      it 'returns correct target_url' do
        input = 's3://sftp.release.clarity.net/test/test.csv'
        assert_equal 's3://filemonitor/test/test.csv', job.target_url(task, input)
      end
    end

    describe 'SFTP protocol' do
      it 'returns correct target_url' do
        task.target_host ='sftp.release.clarity.net'
        task.target_pattern = 'test/*'
        input = 's3://filemonitor/test/test.csv'
        assert_equal 'sftp://sftp.release.clarity.net/test/test.csv', job.target_url(task, input)
      end
    end
  end

  describe 'source_directory' do
    let (:task) { create(:task) }

    describe 'SFTP protocol' do
      it 'returns correct url' do
        task.target_protocol = 'SFTP'

        assert_equal 'sftp://sftp.release.clarity.net', job.source_directory(task)
      end
    end

    describe 'S3 protocol' do
      it 'returns correct url' do
        task.source_protocol = 'S3'
        task.source_host     = 'filemonitor'

        assert_equal 's3://filemonitor', job.source_directory(task)
      end
    end
  end

  describe 'source_credentials' do
    let (:task) { create(:task) }

    describe 'SFTP protocol' do
      it 'returns correct source credentials' do
        expected_args = {
          username: 'source_username',
          password: 'source_password',
          # ssh_options: {
          #   StrictHostKeyChecking: 'no'
          # }

        }
        args          = job.source_credentials(task)

        assert_equal expected_args, args
      end
    end

    describe 'S3 protocol' do
      it 'returns correct source credentials' do
        task.source_protocol = 'S3'
        expected_args        = {
          access_key_id:     'source_username',
          secret_access_key: 'source_password',
        }
        args                 = job.source_credentials(task)

        assert_equal expected_args, args
      end
    end

    describe 'FILE protocol' do
      it 'returns nil' do
        task.source_protocol = 'FILE'

        assert_nil job.source_credentials(task)
      end
    end
  end

  describe 'target_credentials' do
    let (:task) { create(:task) }

    describe 'SFTP protocol' do
      it 'returns correct target credentials' do
        task.target_protocol = 'SFTP'
        expected_args        = {
          username: 'target_username',
          password: 'target_password',
          # ssh_options: {
          #   StrictHostKeyChecking: 'no'
          # }

        }
        args                 = job.target_credentials(task)

        assert_equal expected_args, args
      end
    end

    describe 'S3 protocol' do
      it 'returns correct target credentials' do
        task.target_protocol = 'S3'
        expected_args        = {
          access_key_id:     'target_username',
          secret_access_key: 'target_password',
        }
        args                 = job.target_credentials(task)

        assert_equal expected_args, args
      end
    end

    describe 'FILE protocol' do
      it 'returns nil' do
        task.target_protocol = 'FILE'

        assert_nil job.target_credentials(task)
      end
    end
  end

  # TODO: Had to comment tests below, bc I want to use FILE stream for testing
  # TODO: but IOStreams::Paths::SFTP and IOStreams::Paths::FILE have different interfaces.
  # describe 'perform' do
  #   before do
  #     @task = create(
  #       :task,
  #       source_protocol: 'FILE',
  #       source_host:     File.absolute_path('.'),
  #       source_pattern:  'test_directory/*',
  #       target_protocol: 'FILE',
  #       target_host:     File.absolute_path('.'),
  #       )
  #   end
  #
  #   it 'sets status to Watching if files are empty' do
  #     RocketJob::Jobs::CopyFileJob.delete_all
  #
  #     job.perform_now
  #
  #     # TODO: consider using different structure for files
  #     assert_equal 'Watching', Task.first.files.first.second['status']
  #     puts Task.first.files
  #   end
  #
  #   it 'keeps status at Watching, if status is Watching and the size changed' do
  #     RocketJob::Jobs::CopyFileJob.delete_all
  #     @task.files = {"/Users/smarinskaya/Sandbox/file_monitor/test_directory/test1.csv"=>{"size"=>2, "last_checked"=> 5.minutes.ago, "status"=>"Watching"}}
  #     @task.save
  #
  #     job.perform_now
  #
  #     refute RocketJob::Jobs::CopyFileJob.first
  #     assert_equal 'Watching', Task.first.files.first.second['status']
  #   end
  #
  #   it 'runs the job sets status to Complete, if status is Watching and the size did not change' do
  #     RocketJob::Jobs::CopyFileJob.delete_all
  #     @task.files = {"/Users/smarinskaya/Sandbox/file_monitor/test_directory/test1.csv"=>{"size"=>5, "last_checked"=> 5.minutes.ago, "status"=>"Watching"}}
  #     @task.save
  #
  #     job.perform_now
  #
  #     assert RocketJob::Jobs::CopyFileJob.first
  #
  #     assert_equal 'Complete', Task.first.files.first.second['status']
  #   end
  #
  #   it 'nothing changes, if status is Complete' do
  #     RocketJob::Jobs::CopyFileJob.delete_all
  #     @task.files = {"/Users/smarinskaya/Sandbox/file_monitor/test_directory/test1.csv"=>{"size"=>5, "last_checked"=> 5.minutes.ago, "status"=>"Complete"}}
  #     @task.save
  #
  #     job.perform_now
  #
  #     refute RocketJob::Jobs::CopyFileJob.first
  #
  #     assert_equal 'Complete', Task.first.files.first.second['status']
  #   end
  # end
end
