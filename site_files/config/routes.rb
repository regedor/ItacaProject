ActionController::Routing::Routes.draw do |map|
    map.root :controller => 'pages', :action => 'show', :id => 'about'
  # ==========================================================================
  # public resources
  # ==========================================================================
    map.resources :pages
    map.resources :movies
    map.resources :sound_documents   
    map.resources :writen_documents  
    map.resources :photos   
    map.resources :authors           
    map.resources :directors         
    map.resources :prizes          
    map.resources :locals            
  # ==========================================================================
  # map Admin resources
  # ==========================================================================
  map.namespace :admin do |admin|
    admin.default    '', :controller => 'movies'
    admin.resources :associations
    admin.resources :writen_documents,:member => {:delete => :get}, :collection => {:grid_data => :post}
    admin.resources :photos,          :member => {:delete => :get}, :collection => {:grid_data => :post}
    admin.resources :sound_documents, :member => {:delete => :get}, :collection => {:grid_data => :post}
    admin.resources :movies,          :member => {:delete => :get}, :collection => {:grid_data => :post}
    admin.resources :locals,          :member => {:delete => :get}, :collection => {:grid_data => :post}
    admin.resources :countries,       :member => {:delete => :get}, :collection => {:grid_data => :post}
    admin.resources :document_types,  :member => {:delete => :get}, :collection => {:grid_data => :post}
    admin.resources :music_genres,    :member => {:delete => :get}, :collection => {:grid_data => :post}
    admin.resources :categories,      :member => {:delete => :get}, :collection => {:grid_data => :post}
    admin.resources :subcategories,   :member => {:delete => :get}, :collection => {:grid_data => :post}
    admin.resources :genres,          :member => {:delete => :get}, :collection => {:grid_data => :post}
    admin.resources :prizes,          :member => {:delete => :get}, :collection => {:grid_data => :post}
    admin.resources :directors,       :member => {:delete => :get}, :collection => {:grid_data => :post}
    admin.resources :authors,         :member => {:delete => :get}, :collection => {:grid_data => :post}
    admin.resources :users,           :member => {:delete => :get}, :collection => {:grid_data => :post}
  end

  # ==========================================================================
  # sessions controller
  # ==========================================================================
  map.resource :session
  map.resources :users
  map.logout   '/logout',   :controller => 'sessions', :action => 'destroy'
  map.login    '/login',    :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users',    :action => 'create'
  map.signup   '/signup',   :controller => 'users',    :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
