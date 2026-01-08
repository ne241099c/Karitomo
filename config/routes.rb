Rails.application.routes.draw do
  root "top#index"

  resources :members, only: [:index, :show] do
    get "search", on: :collection
    resource :block, only: [:create, :destroy]
    resource :bookmark, only: [:create, :destroy]
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
    resources :chats, only: [:index, :create]
    resource :review, only: [:create]
    resource :report, only: [:create]
  end

  resources :blocks, only: [:index]

  resources :contacts, only: [:new, :create]

  namespace :admin do
    root "top#index"
    resource :session, only: [:new, :create, :destroy]
    
    resources :members        # 会員管理
    resources :tags           # タグ管理
    resources :regions        # 地域管理
    resources :reservations   # 予約管理
    resources :contacts       # お問い合わせ管理
    resources :reports        # 通報管理
  end

  mount ActionCable.server => '/cable'
end
