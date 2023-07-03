Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'dashboard#index'

  resources :patients, only: :index do
    collection { post :import }
  end

  resources :data_migrations, only: %i[index show]
end
