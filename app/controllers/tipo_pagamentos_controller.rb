class TipoPagamentosController < ApplicationController
  layout "adm"
  before_filter :require_user 
  # GET /tipo_pagamentos
  # GET /tipo_pagamentos.xml
  def index
    @tipo_pagamentos = TipoPagamento.da_clinica(session[:clinica_id]).por_nome

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tipo_pagamentos }
    end
  end

  # GET /tipo_pagamentos/1
  # GET /tipo_pagamentos/1.xml
  def show
    @tipo_pagamento = TipoPagamento.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tipo_pagamento }
    end
  end

  # GET /tipo_pagamentos/new
  # GET /tipo_pagamentos/new.xml
  def new
    @tipo_pagamento = TipoPagamento.new
    @tipo_pagamento.clinica_id = session[:clinica_id]
    @tipo_pagamento.ativo = true
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tipo_pagamento }
    end
  end

  # GET /tipo_pagamentos/1/edit
  def edit
    @tipo_pagamento = TipoPagamento.find(params[:id])
  end

  # POST /tipo_pagamentos
  # POST /tipo_pagamentos.xml
  def create
    @tipo_pagamento = TipoPagamento.new(params[:tipo_pagamento])

    respond_to do |format|
      if @tipo_pagamento.save
        flash[:notice] = 'TipoPagamento was successfully created.'
        format.html { redirect_to(tipo_pagamentos_path) }
        format.xml  { render :xml => @tipo_pagamento, :status => :created, :location => @tipo_pagamento }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tipo_pagamento.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tipo_pagamentos/1
  # PUT /tipo_pagamentos/1.xml
  def update
    @tipo_pagamento = TipoPagamento.find(params[:id])

    respond_to do |format|
      if @tipo_pagamento.update_attributes(params[:tipo_pagamento])
        flash[:notice] = 'TipoPagamento alterado com sucesso.'
        format.html { redirect_to(@tipo_pagamento) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tipo_pagamento.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tipo_pagamentos/1
  # DELETE /tipo_pagamentos/1.xml
  def destroy
    @tipo_pagamento = TipoPagamento.find(params[:id])
    @tipo_pagamento.ativo = false
    @tipo_pagamento.save

    respond_to do |format|
      format.html { redirect_to(tipo_pagamentos_url) }
      format.xml  { head :ok }
    end
  end
  
  def reativar
    @tipo_pagamento = TipoPagamento.find(params[:id])
    @tipo_pagamento.ativo = true
    @tipo_pagamento.save

    respond_to do |format|
      format.html { redirect_to(tipo_pagamentos_url) }
      format.xml  { head :ok }
    end
  end
end
