Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'data_migrations#index'

  resources :patients, only: :index do
    collection { post :import }
  end
end
