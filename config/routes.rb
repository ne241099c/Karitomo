Rails.application.routes.draw do
  root "top#index"

  resources :members, only: [:index, :show] do
    get "search", on: :collection
    resource :block, only: [:create, :destroy]
    resource :bookmark, only: [:create, :destroy]
    resources :reservations, only: [:new, :create]
  end

  resource :session, only: [:new, :create, :destroy]
  get "login", to: "sessions#new"
  get "logout", to: "sessions#destroy"
  
  resource :account, only: [:new, :create, :show, :edit, :update] do
    post :details, on: :member
  end

  resource :password, only: [:show, :edit, :update]

  resources :reservations, only: [:index, :create, :show] do
    post :confirm, on: :collection
    patch :update_status, on: :member
    patch :cancel, on: :member
    patch :pay, on: :member
    resources :chats, only: [:index, :create]
    resource :review, only: [:create]
    resource :report, only: [:create, :new]
  end

  resources :blocks, only: [:index]

  resources :bookmarks, only: [:index]

  resources :contacts, only: [:new, :create]

  namespace :admin do
    root "top#index"
    resource :session, only: [:new, :create, :destroy]
    get "statistics", to: "statistics#index"
    
    resources :members do
      patch :ban, on: :member
      patch :unban, on: :member
      get :chats, on: :member
    end
    resources :tags
    resources :regions
    resources :reservations, only: [:index, :show] do
      get :chats, on: :member
      patch :cancel, on: :member
      patch :restore, on: :member
    end
    resources :chats, only: [:destroy]
    resources :contacts
    resources :reports
    resources :reviews, only: [:index, :destroy]
    resources :blocked_members, only: [:index, :destroy]
  end

  mount ActionCable.server => '/cable'
end
