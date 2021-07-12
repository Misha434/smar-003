Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions', users: 'users' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: [:index, :show]
  # get '/contact', to: 'pages#contact'
  get '/terms', to: 'pages#terms'
	root 'pages#home'
  namespace :reviews do 
    resources :picks, only: :index, defaults: { format: :json }
  end
  resources :reviews, only: [:create, :destroy, :new, :edit, :update]
  resources :products do
	  # post :import, on: :collection
    get :search, on: :collection
	end
	resources :brands 
	resources :brands do
	  post :import, on: :collection
	end
  post 'like/:id' => 'likes#create', as: 'create_like'
  delete 'like/:id' => 'likes#destroy', as: 'destroy_like'
end
