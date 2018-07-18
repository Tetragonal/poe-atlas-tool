Rails.application.routes.draw do
  root to: 'landing#index'
  get 'landing/index'

  # Api definition
  namespace :api do
    namespace :v1 do
      # resources :base
      get "/base" => "base#get"
      post "/base" => "base#post"
    end
  end
end
