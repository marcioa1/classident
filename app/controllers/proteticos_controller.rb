class ProteticosController < ApplicationController
  layout "adm"
  before_filter :require_user
  before_filter :busca_protetico, :only => [:edit, :abre, :show, :update, :destroy]
  
  def index
    if administracao?
      @proteticos = Protetico.por_nome
    else
      @proteticos = @clinica_atual.proteticos.por_nome
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @proteticos }
    end
  end

  def show
    @protetico = Protetico.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @protetico }
    end
  end

  def new
    @protetico = Protetico.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @protetico }
    end
  end

  def edit
  end

  def create
    @protetico            = Protetico.new(params[:protetico])
    @protetico.clinica_id = session[:clinica_id]
    
    respond_to do |format|
      if @protetico.save
        flash[:notice] = 'Protético salvo com sucesso.'
        format.html { redirect_to(proteticos_path) }
        format.xml  { render :xml => @protetico, :status => :created, :location => @protetico }
      else
         @clinicas = Clinica.por_nome
        format.html { render :action => "new" }
        format.xml  { render :xml => @protetico.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @protetico.update_attributes(params[:protetico])
        flash[:notice] = 'Protético alterado com sucesso.'
        format.html { redirect_to(proteticos_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @protetico.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @protetico.destroy

    respond_to do |format|
      format.html { redirect_to(proteticos_url) }
      format.xml  { head :ok }
    end
  end
  
  def abre
    @clinicas = Clinica.por_nome - Clinica.administracao
    if administracao?
      @trabalhos_pendentes = TrabalhoProtetico.do_protetico(@protetico.id).pendentes
      @trabalhos_devolvidos = TrabalhoProtetico.do_protetico(@protetico.id).devolvidos.nao_pagos
    else
      @trabalhos_pendentes = TrabalhoProtetico.do_protetico(@protetico.id).pendentes.da_clinica(session[:clinica_id])
      @trabalhos_devolvidos = TrabalhoProtetico.do_protetico(@protetico.id).devolvidos.
             da_clinica(session[:clinica_id]).nao_pagos
    end
    @pagamentos = Pagamento.ao_protetico(@protetico.id)
  end
  
  def busca_tabela
    @protetico = Protetico.find(params[:protetico_id])
    render :json=>@protetico.tabela_proteticos.por_descricao.collect{|obj| [obj.descricao,obj.id]}.to_json
  end
  
  def relatorio
    if params[:datepicker]
      @inicio = params[:datepicker].to_date
      @fim = params[:datepicker2].to_date
    else
      @inicio = Date.today
      @fim = Date.today
    end
    @trabalhos_pendentes = TrabalhoProtetico.pendentes.entre_datas(@inicio,@fim).da_clinica(session[:clinica_id])
    @trabalhos_devolvidos = TrabalhoProtetico.devolvidos.entre_datas(@inicio,@fim).da_clinica(session[:clinica_id])
    if params[:protetico].to_i > 0
      @trabalhos_pendentes = @trabalhos_pendentes.do_protetico(params[:protetico]) 
      @trabalhos_devolvidos = @trabalhos_devolvidos.do_protetico(params[:protetico]) 
    end
    @proteticos = Clinica.find(session[:clinica_id]).proteticos.por_nome.collect{|obj| [obj.nome, obj.id.to_s]}.insert(0, '')
  end

  def busca_protetico
     @protetico = Protetico.find(params[:id])
  end  
  
end
