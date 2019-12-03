# frozen_string_literal: true

require 'rails_helper'

describe Task do
  it 'has valid factory' do
    expect(create(:task)).to be_valid
  end

  it 'is invalid without task name' do
    expect(build(:task, task_name: '')).to_not be_valid
  end

  it 'is invalid without target host' do
    expect(build(:task, target_host: '')).to_not be_valid
  end

  it 'is invalid without target protocol' do
    expect(build(:task, target_protocol: '')).to_not be_valid
  end

  it 'is invalid without target format' do
    expect(build(:task, target_format: '')).to_not be_valid
  end

  it 'is invalid without target stream' do
    expect(build(:task, target_stream: '')).to_not be_valid
  end

  it 'is invalid without target username' do
    expect(build(:task, target_username: '')).to_not be_valid
  end

  it 'is invalid without source host' do
    expect(build(:task, source_host: '')).to_not be_valid
  end

  it 'is invalid without source protocol' do
    expect(build(:task, source_protocol: '')).to_not be_valid
  end

  it 'is invalid without source format' do
    expect(build(:task, source_format: '')).to_not be_valid
  end

  it 'is invalid without source stream' do
    expect(build(:task, source_stream: '')).to_not be_valid
  end

  it 'is invalid without source username' do
    expect(build(:task, source_username: '')).to_not be_valid
  end

  it 'has unique target password' do
    create(:task)
    expect(
      build(:task, task_name: 'Second Task', source_password: 'New Source Password')
    ).to_not be_valid
  end

  it 'has unique source password' do
    create(:task)
    expect(
      build(:task, task_name: 'Second Task', target_password: 'New Target Password')
    ).to_not be_valid
  end
end
