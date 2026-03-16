# frozen_string_literal: true

Rails.application.routes.draw do
  get "pipeline_runs/index"
  get "pipeline_runs/create"
  get "pipeline_runs/update"
  get 'welcome/index'

  resources :articles do
    resources :comments
  end

  root 'welcome#index'
end
