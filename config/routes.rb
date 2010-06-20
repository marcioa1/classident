ActionController::Routing::Routes.draw do |map|

  map.resources :altas
  map.resources :bancos
  map.resources :cheques, :collection=>{:busca_disponiveis=>:get, :cheques_recebidos=>:get, 
       :recebe_cheques=>:get,:confirma_recebimento=>:get, 
       :registra_recebimento_de_cheques=>:get, :recebimento_confirmado=>:get, :pesquisa=>:get}
                
  map.resource :clinicas, :collection=>{:producao_entre_datas=>:get, :producao_anual=>:get,
       :relatorio_alta=>:get, :abandono_de_tratamento=>:get, :pacientes_de_ortodontia =>:get,
       :fechamento_mes=>:get }
  map.resources :conta_bancarias
  map.resources :conversao
  map.resources :debitos, :collection=>{:pacientes_em_debito=>:get, :pacientes_fora_da_lista=>:get}
  map.resources :dentistas, :member=>{:abre=>:get, :producao=>:get, :pagamento=>:get,:orcamentos=>:get, :reativar=>:get}, 
                    :collection=>{:pesquisar=>:get, :producao_geral=>:get, 
                    :producao_geral => :get }
  map.resources :descricao_condutas
  map.resources :destinacaos
  map.resources :entradas, :collection=>{ :administracao => :get, :registra_confirmacao_de_entrada => :post }
  map.fluxo_de_caixa "fluxo_de_caixa", :controller=>"fluxo_de_caixa", :action=>"index"
  map.conserta_saldo 'conserta_saldo', :controller=>'fluxo_de_caixa', :action=>'conserta_saldo'
  map.busca_saldo 'busca_saldo',       :controller=>'fluxo_de_caixa', :action=>'busca_saldo'
  map.grava_saldo 'grava_saldo',       :controller=>'fluxo_de_caixa', :action=>'grava_saldo'
  map.resources :formas_recebimentos
  map.resources :indicacaos
  
  map.resources :item_tabelas, :collection=>{:busca_descricao=>:get}
  map.resources :orcamentos, 
                  :collection=>{:relatorio=>:get, :aproveitamento=>:get, :monta_tabela_de_parcelas => :get}
  map.resources :pacientes, 
                  :collection=>{:pesquisa=>:get,:nomes_que_iniciam_com=>:get, 
                                :pesquisa_nomes=> :get, :retorna_paciente_por_nome=>:get},
                  :member => {:abre=>:get}

  map.administracao "administracao", :controller=>"administracao", :action=>"index"
  map.resources :pagamentos, :collection=>{:relatorio=>:get}
  map.resources :precos
  map.resources :proteticos, :member=>{:abre=>:get}, 
        :collection=>{:busca_tabela=>:get, :relatorio=>:get, :trabalhos_por_clinica => :get, :busca_proteticos_da_clinica => :get}
  map.resources :recebimentos, :collection=>{:relatorio=>:get, :das_clinicas=>:get, :entradas_no_mes=>:get}
  map.resources :tabelas, :collection=>{:print=>:get },
                  :member => {:reativar => :get}

  map.resources :tabelas do |item|
     item.resources :item_tabelas
  end
  map.resources :tabela_proteticos, 
                :collection=>{:importa_tabela_base=>:get,:busca_valor=>:get}
  map.resources :tipo_pagamentos, :member=>{:reativar=>:get}
  map.resources :trabalho_proteticos
  map.resources :tratamentos, :member=>{:finalizar_procedimento=>:get}
  map.resources :users, :member =>[:troca_senha=>:get]
  map.resource :user_sessions
  
  
  map.registra_devolucao_de_trabalho '/registra_devolucao_de_trabalho',
             :controller=>'trabalho_proteticos',
             :action=>'registra_devolucao_de_trabalho'

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
