# frozen_string_literal: true

Rails.application.routes.draw do
  # Api definition
  namespace :api do
    namespace :v1 do
      post '/users/:account_name' => 'users#post', as: 'account_name'

      post '/progressions/:account_name' => 'progressions#post'
      get '/progressions/:account_name' => 'progressions#get'

      get '/maps' => 'maps#get'

      get '/leagues' => 'leagues#get'
      post '/leagues/:name' => 'leagues#post'
      patch '/leagues/:name' => 'leagues#patch'
      delete '/leagues/:name' => 'leagues#delete'

      namespace :admin do
      end
    end
  end

  root to: 'landing#index'
  match '*path', to: 'landing#index', format: false, via: :get
end
