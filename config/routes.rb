Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions', users: 'users' }
  resources :users, only: [:index, :show]
  get '/terms', to: 'pages#terms'
	root 'pages#home'
  namespace :reviews do 
    resources :picks, only: :index, defaults: { format: :json }
  end
  resources :reviews, only: [:create, :destroy, :new, :edit, :update]
  namespace :products do 
    resources :searches, only: :index
  end
  resources :brands, :products
  post 'like/:id' => 'likes#create', as: 'create_like'
  delete 'like/:id' => 'likes#destroy', as: 'destroy_like'
end
