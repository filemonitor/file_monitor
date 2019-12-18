# frozen_string_literal: true

require 'rails_helper'

describe Task do
  it 'has valid factory' do
    expect(create(:task)).to be_valid
  end

  it 'is invalid without task name' do
    expect(build(:task, task_name: '')).not_to be_valid
  end

  it 'is invalid without target host' do
    expect(build(:task, target_host: '')).not_to be_valid
  end

  it 'is invalid without target protocol' do
    expect(build(:task, target_protocol: '')).not_to be_valid
  end

  it 'is invalid without target format' do
    expect(build(:task, target_format: '')).not_to be_valid
  end

  it 'is invalid without target stream' do
    expect(build(:task, target_stream: '')).not_to be_valid
  end

  it 'is invalid without target username' do
    expect(build(:task, target_username: '')).not_to be_valid
  end

  it 'is invalid without source host' do
    expect(build(:task, source_host: '')).not_to be_valid
  end

  it 'is invalid without source protocol' do
    expect(build(:task, source_protocol: '')).not_to be_valid
  end

  it 'is invalid without source format' do
    expect(build(:task, source_format: '')).not_to be_valid
  end

  it 'is invalid without source stream' do
    expect(build(:task, source_stream: '')).not_to be_valid
  end

  it 'is invalid without source username' do
    expect(build(:task, source_username: '')).not_to be_valid
  end
end
