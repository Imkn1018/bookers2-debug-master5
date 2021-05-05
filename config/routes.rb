Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
  get 'home/about' => 'homes#about', as: 'about'
  resources :homes, only: [:about]
  resources :users
  resources :books
  
  resources :users do
    resource :relationships, only: [:create, :destroy]
      get :follows, on: :member
      get :followers, on: :member
  end
  get "search" => "search#search"
end
