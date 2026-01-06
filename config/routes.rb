Rails.application.routes.draw do
  root "top#index"

  resources :members, only: [:index, :show] do
    get "search", on: :collection
  end

  resource :session, only: [:new, :create, :destroy]
  get "login", to: "sessions#new"
  get "logout", to: "sessions#destroy"
  
  resource :account, only: [:new, :create, :show, :edit, :update] do
    post :details, on: :member
  end
  resource :password, only: [:show, :edit, :update]
end
