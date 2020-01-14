# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FileMonitorJob, type: :job do
  let (:job) { FileMonitorJob.new }

  let (:input) { "sftp://sftp.release.clarity.net/test/test.csv" }

  describe 'target_url' do
    let (:task) { create(:task) }

    it 'returns correct target_url' do
      assert_equal "s3://filemonitor/test/test.csv", job.target_url(task, input)
    end
  end

  describe 'source_directory' do
    let (:task) { create(:task) }

    it 'returns correct url' do
      assert_equal "sftp://sftp.release.clarity.net", job.source_directory(task)
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