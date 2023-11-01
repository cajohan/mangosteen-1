Rails.application.routes.draw do
  get 'validation_codes/create'
  # post '/users', to: 'users#create'
  # get '/users/:id', to: 'users#show'
  # post '/validation_codes', to: 'validationCodes#create'

  namespace :api do
    namespace :v1 do
      # /api/v1
      resources :validation_codes, only: [:create]
      resource :sessions, only: [:create, :destroy]
      resource :me, only: [:show]
      resources :items
      resources :tags
    end
  end

end
