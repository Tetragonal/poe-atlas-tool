Rails.application.routes.draw do
  root to: 'landing#index'
  get 'landing/index'

  # Api definition
  namespace :api do
    namespace :v1 do
      resources :base
    end
  end
end
