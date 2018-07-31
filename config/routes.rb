# frozen_string_literal: true

Rails.application.routes.draw do

  # Api definition
  namespace :api do
    namespace :v1 do
      # resources :base
      get '/users' => 'users#get'
      post '/users/:account_name' => 'users#post', as: 'account_name'

      post '/progressions' => 'progressions#post'
    end
  end

  root :to => "landing#index"
  match "*path", to: "landing#index", format: false, via: :get

end
