ActionController::Routing::Routes.draw do |map|
  map.resources :bancos

 
  map.resources :debitos
  map.resources :dentistas, :member=>{:abre=>:get, :producao=>:get}
  map.resources :formas_recebimentos
  map.resources :item_tabelas, :collection=>{:busca_descricao=>:get}
  map.resources :pacientes, :member=>{:abre=>:get}, :collection=>{:pesquisa=>:get}

  map.administracao "administracao", :controller=>"administracao", :action=>"index"
  map.resources :pagamentos, :collection=>{:relatorio=>:get}
  map.resources :precos
  map.resources :recebimentos, :collection=>{:relatorio=>:get, :cheques_recebidos=>:get}
  map.resources :tabelas do |item|
     item.resources :item_tabelas
  end
  map.resources :tipo_pagamentos
  map.resources :tratamentos
  map.resources :users, :member =>[:troca_senha=>:get]
  map.resource :user_sessions

  map.selecionou_clinica "selecionou_clinica", :controller=>:clinicas, :action=>:selecionou_clinica
  map.root :controller => "user_sessions", :action => "new" # optional, this just sets the root route
  map.logout "logout", :controller=>:user_sessions, :action=>:destroy
  map.troca_senha "troca_senha", :controller=>:users, :action=>:troca_senha
  map.grava_precos "grava_precos", :controller => "item_tabelas", :action=>"grava_precos"
#  map.resource :account, :controller => "users"
  
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
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
