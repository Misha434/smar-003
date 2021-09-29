Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions', users: 'users', passwords: 'users/passwords' }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  resources :users, only: [:index, :show]
  get '/terms', to: 'pages#terms'
	root 'pages#home'
  namespace :reviews do 
    resources :picks, only: :index, defaults: { format: :json }
  end
  namespace :products do 
    get 'search', to: 'products#search'
  end
  resources :brands do
	  post :import, on: :collection
	end
  resources :products do
    post :import, on: :collection
  end
  resources :reviews
  post 'compare/:id' => 'compares#create', as: 'create_compare'
  delete 'compare/:id' => 'compares#destroy', as: 'destroy_compare'
  post 'like/:id' => 'likes#create', as: 'create_like'
  delete 'like/:id' => 'likes#destroy', as: 'destroy_like'
end
