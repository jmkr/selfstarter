Selfstarter::Application.routes.draw do
  root :to => 'root#index'

  resources :email_lists, only: [:create]
  resources :orders, only: [:new, :index, :create, :show] do
  	resources :shipments, only: [:index]

  	member do
  		get "cancel"
  	end
  end

  get '/faq',     to: 'static_pages#faq'
  get '/about',   to: 'static_pages#about'
  get '/diy',     to: 'static_pages#diy'
  get '/crate',   to: 'static_pages#crate'
  get '/contact', to: 'static_pages#contact'
  
  get "users/settings"
  devise_for :users

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

end