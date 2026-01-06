Rails.application.routes.draw do
  root "top#index"

  resources :members, only: [:index, :show] do
    get "search", on: :collection
  end
end
