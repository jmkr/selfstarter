Selfstarter::Application.routes.draw do
  root :to => 'root#index'

  resources :orders, only: [:new, :index, :create] do
  	member do
  		get "cancel"
  	end
  end

  get "users/settings"
  devise_for :users

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

end