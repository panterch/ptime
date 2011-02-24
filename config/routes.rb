PanterControlling::Application.routes.draw do

  resources :projects

  devise_for :users

  root :to => 'projects#index'
  resources :posts

  match '/exception_test' => 'exception_test#error'
end
