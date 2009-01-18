ActionController::Routing::Routes.draw do |map|

  # The priority is based upon order of creation: first created -> highest priority.
  
  map.connect '', :controller => "entries"

  map.resources :users
  map.resources :entries

  map.connect ':controller/:action.:format'
  map.connect ':controller/:action/:id'
end
