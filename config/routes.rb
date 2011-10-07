PanterControlling::Application.routes.draw do

  match '/admin' => "admin#index"

  resource :report

  resources :project_states

  resources :entries

  resources :projects do
    resources :accountings
    resources :milestones
    resources :responsibilities
  end

  devise_for :users do
    get "/users/sign_out" => "devise/sessions#destroy", :as => :destroy_user_session
  end

  resources :users

  resources :milestone_types

  resources :responsibility_types

  root :to => 'entries#new'

  match '/exception_test' => 'exception_test#error'
end
