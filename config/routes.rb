ActionController::Routing::Routes.draw do |map|
	map.root :controller => "dashboards"
  map.resources :roles

  map.login 'faq', :controller => 'faq', :action => 'index'  
  map.login 'login', :controller => 'user_sessions', :action => 'new'  
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.register '/register/:activation_code', :controller => 'activations', :action => 'new'
  map.activate '/activate/:id', :controller => 'activations', :action => 'create'

  map.resources :groups, :member => { :add_member => :post, :add_widget => :post, :delete_member => :post, :delete_widget => :post }

  # do |group|
  #     group.resources :widgets, :controller => "groups_widgets"
  #     group.resources :members, :controller => "groups_members"
  #   end
  
  map.resources :widgets, :has_many => [:comments, :ratings], :shallow => true 
  map.resources :user_sessions
  map.resources :users
  map.resources :categories
  map.resources :containers, :member => { :save_preferences => :post }
  map.resources :dashboards
  map.resources :tabs
  map.resources :ratings
  map.resources :requests
  
  map.resources :themes, :member => { :apply => :post }
  map.resources :requests
  map.resources :password_resets, :only => [:new, :create, :edit, :update]

end
