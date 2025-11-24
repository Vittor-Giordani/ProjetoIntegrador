Rails.application.routes.draw do
  root "sessions#new"

  get "login",  to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  get "signup", to: "users#new"
  post "signup", to: "users#create"

  get "dashboard", to: "dashboard#index"

  get "dashboard/produtos", to: "dashboard#produtos"

  resources :products
  resources :produtos, controller: "products" 

  get 'produtos.html', to: "dashboard#produtos"
  get "dashboard/charts.html", to: "dashboard#charts"
  #get "dashboard/layoutstatic.html", to: "dashboard#layoutstatic"
  #get "dashboard/layoutsidenavlight.html", to: "dashboard#layoutsidenavlight"
end
