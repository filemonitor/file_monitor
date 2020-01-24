# frozen_string_literal: true

Rails.application.routes.draw do
  resources :tasks

  root 'tasks#index'

  devise_for :users

  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
  end

  scope :admin do
    get :health_check, to: 'admin/monitor#health_check'
  end

  mount RocketJobMissionControl::Engine => 'rocketjob'
end
