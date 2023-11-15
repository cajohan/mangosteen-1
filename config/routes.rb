Rails.application.routes.draw do
  # get 'home/index'
  # get 'validation_codes/create'
  # post '/users', to: 'users#create'
  # get '/users/:id', to: 'users#show'
  # post '/validation_codes', to: 'validationCodes#create'
  get '/', to: 'home#index'

  namespace :api do
    namespace :v1 do
      # /api/v1
      resources :validation_codes, only: [:create]
      resource :session, only: [:create, :destroy]
      resource :me, only: [:show]
      resources :items do
        collection do
          get :summary
        end
      end
      resources :tags
    end
  end

end
