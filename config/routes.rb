Rails.application.routes.draw do
  get 'relatorios/index'
  get 'mesas/index'
  get 'mesas/new'
  get 'mesas/edit'
  root "sessions#new"

  get "login",  to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  get "signup", to: "users#new"
  post "signup", to: "users#create"

  get "dashboard", to: "dashboard#index"
  get "dashboard/produtos", to: "dashboard#produtos"
  get 'dashboard/mesas', to: 'mesas#index'
  delete "logout", to: "sessions#destroy"

  resources :mesas do
    member do
      post :fechar_conta 
      post :reativar
    end
    resources :pedidos, only: [:index, :create], controller: 'pedidos'
  end

  resources :relatorios, only: [:index] do
    collection do
      get :pedidos, defaults: { format: :csv }
      get :mesas_pessoas, defaults: { format: :csv }
    end
  end

  resources :products
  resources :logs, only: [:index]
  resources :garcons
  
  resources :itens_pedidos, only: [:create, :destroy], as: 'itens_pedidos' 
end