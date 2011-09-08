PanterControlling::Application.routes.draw do

  match '/admin' => "admin#index"

  resource :report

  resources :accountings

  resources :project_states, :only => [:new, :create, :index]

  resources :entries

  resources :projects

  devise_for :users
  
  resources :users
  
  root :to => 'entries#new'

  match '/exception_test' => 'exception_test#error'
end
