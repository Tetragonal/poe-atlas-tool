# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'landing#index'
  get 'landing/index'

  # Api definition
  namespace :api do
    namespace :v1 do
      # resources :base
      get '/users' => 'users#get'
      post '/users' => 'users#post'
    end
  end
end
