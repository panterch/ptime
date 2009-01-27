ActionController::Routing::Routes.draw do |map|

  # The priority is based upon order of creation: first created -> highest priority.
  
  map.connect '', :controller => "entries"

  map.resource :user
  map.resource :reports
  map.resources :projects do |projects|
    projects.resources :engagements
  end
  map.resources :entries

  map.connect ':controller/:action.:format'
  map.connect ':controller/:action/:id'
end
