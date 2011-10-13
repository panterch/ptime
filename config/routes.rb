PanterControlling::Application.routes.draw do

  resource :report

  resources :project_states

  resources :entries

  resources :tasks

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

  # Unknown routes
  match '/errors/403' => 'errors#render_403', :as => :render_403
  match '/errors/404' => 'errors#render_404', :as => :render_404
  match '*a', :to => 'errors#render_404'
end
