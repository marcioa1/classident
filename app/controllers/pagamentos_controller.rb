class PagamentosController < ApplicationController
  
  layout "adm"
  # GET /pagamentos
  # GET /pagamentos.xml
  def index
    @pagamentos = Pagamento.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pagamentos }
    end
  end

  # GET /pagamentos/1
  # GET /pagamentos/1.xml
  def show
    @pagamento = Pagamento.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pagamento }
    end
  end

  # GET /pagamentos/new
  # GET /pagamentos/new.xml
  def new
    @tipos_pagamento = TipoPagamento.por_nome.collect{|obj| [obj.nome, obj.id]}
    @pagamento = Pagamento.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pagamento }
    end
  end

  # GET /pagamentos/1/edit
  def edit
    @tipos_pagamento = TipoPagamento.por_nome.collect{|obj| [obj.nome, obj.id]}
    @pagamento = Pagamento.find(params[:id])
  end

  # POST /pagamentos
  # POST /pagamentos.xml
  def create
    @pagamento = Pagamento.new(params[:pagamento])
    @pagamento.clinica_id = session[:clinica_id]
    respond_to do |format|
      if @pagamento.save
        flash[:notice] = 'Pagamento criado com sucesso.'
        format.html { redirect_to(@pagamento) }
        format.xml  { render :xml => @pagamento, :status => :created, :location => @pagamento }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pagamento.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pagamentos/1
  # PUT /pagamentos/1.xml
  def update
    @pagamento = Pagamento.find(params[:id])

    respond_to do |format|
      if @pagamento.update_attributes(params[:pagamento])
        flash[:notice] = 'Pagamento was successfully updated.'
        format.html { redirect_to(@pagamento) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pagamento.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pagamentos/1
  # DELETE /pagamentos/1.xml
  def destroy
    @pagamento = Pagamento.find(params[:id])
    @pagamento.data_da_exclusa = Time.now
    @pagamento.save

    respond_to do |format|
      format.html { redirect_to(pagamentos_url) }
      format.xml  { head :ok }
    end
  end
  
   def relatorio
     @tipos_pagamento = TipoPagamento.por_nome.collect{|obj| [obj.nome, obj.id]}
     if params[:inicio]
       @data_inicial = Date.new(params[:inicio][:year].to_i, 
                 params[:inicio][:month].to_i, 
                 params[:inicio][:day].to_i)
       @data_final = Date.new(params[:fim][:year].to_i,
                params[:fim][:month].to_i, 
                params[:fim][:day].to_i)
     else
       @data_inicial = Date.today 
       @data_final = Date.today
     end
     @pagamentos = Pagamento.por_data.entre_datas(@data_inicial, @data_final)
     respond_to do |format|
       format.html # index.html.erb
       format.xml  { render :xml => @pagamentos }
     end
   end
end
