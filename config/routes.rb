PanterControlling::Application.routes.draw do

  match '/admin' => "admin#index"

  scope "/controlling" do
    resource :report
  end

  scope "/admin" do
    resources :project_states, :only => [:new, :create, :index]
    resources :projects
    resources :users
  end

  resources :entries

  devise_for :users
  
  root :to => 'entries#new'

  match '/exception_test' => 'exception_test#error'
end
