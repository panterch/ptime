PanterControlling::Application.routes.draw do

  match 'entries/update_tasks_select/:id', :controller => 'entries', 
                                           :action => 'update_tasks_select'

  resources :entries

  resources :projects

  devise_for :users
  
  resources :users
  
  root :to => 'projects#index'
  resources :posts

  match '/exception_test' => 'exception_test#error'
end
