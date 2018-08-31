# frozen_string_literal: true

Rails.application.routes.draw do
  # Api definition
  namespace :api do
    namespace :v1 do
      post '/users/:account_name' => 'users#post'
      post '/users/:account_name/set_public' => 'users#set_public'
      get '/users/:account_name/random' => 'users#random_get'

      post '/progressions/:account_name' => 'progressions#post'
      get '/progressions/:account_name' => 'progressions#get'

      post '/stashed_maps/:account_name' => 'stashed_maps#post'
      get '/stashed_maps/:account_name' => 'stashed_maps#get'


      get '/maps' => 'maps#get'

      get '/leagues' => 'leagues#get'
      post '/leagues/:name' => 'leagues#post'
      patch '/leagues/:name' => 'leagues#patch'
      delete '/leagues/:name' => 'leagues#delete'

      post '/login' => 'login#post'

      namespace :admin do
      end
    end
  end

  root to: 'landing#index'
  match '*path', to: 'landing#index', format: false, via: :get, constraints: lambda{ |req| !req.env['PATH_INFO'].start_with?('/api') }
end
