class PagamentosController < ApplicationController
  
  layout "adm" , :except=> :show
  before_filter :require_user
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
    if params[:trabalho_protetico_id].blank?
      session[:trabalho_protetico_id] = nil
    else
      session[:trabalho_protetico_id] = params[:trabalho_protetico_id] 
    end
    if !params[:protetico_id].blank? 
       session[:protetico_id] = params[:protetico_id]
       @protetico = Protetico.find(params[:protetico_id])
    else 
      session[:protetico_id] = nil 
    end
    @tipos_pagamento = TipoPagamento.da_clinica(session[:clinica_id]).ativos.por_nome.collect{|obj| [obj.nome, obj.id]}
    @pagamento = Pagamento.new
    if params[:valor]
      @pagamento.valor = params[:valor]
    end
    @contas_bancarias = ContaBancaria.all.collect{|obj| [obj.nome, obj.id]}
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pagamento }
    end
  end

  # GET /pagamentos/1/edit
  def edit
    @tipos_pagamento = TipoPagamento.por_nome.collect{|obj| [obj.nome, obj.id]}
    @pagamento = Pagamento.find(params[:id])
    @contas_bancarias = ContaBancaria.all.collect{|obj| [obj.nome, obj.id]}
  end

  # POST /pagamentos
  # POST /pagamentos.xml
  def create
    #FIXME não está salvando os cheques utilizados
    @pagamento = Pagamento.new(params[:pagamento])
    @pagamento.data_de_pagamento = params[:datepicker].to_date
    @pagamento.clinica_id = session[:clinica_id]
    if params[:opcao_restante]!="pago_em_cheque"
      @pagamento.conta_bancaria_id = nil
    end
    @pagamento.protetico_id = session[:protetico_id] if !session[:protetico_id].nil?
    respond_to do |format|
      Pagamento.transaction do
        cheques = Cheque.all(:conditions=>["id in (?)",params[:cheques_ids][0..(params[:cheques_ids].size-2)]])
        @pagamento.cheques << cheques
          if @pagamento.save
            if !session[:trabalho_protetico_id].nil?
              ids = session[:trabalho_protetico_id].split(",")
              ids.each do |id|
                trab = TrabalhoProtetico.find(id)
                trab.pagamento_id = @pagamento.id
                trab.save
              end
            end
            flash[:notice] = 'Pagamento criado com sucesso.'
            format.html { redirect_to(@pagamento) }#TODO retornar para tela anterior
            format.xml  { render :xml => @pagamento, :status => :created, :location => @pagamento }
          else
            format.html { render :action => "new" }
            format.xml  { render :xml => @pagamento.errors, :status => :unprocessable_entity }
        end
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
    @pagamento.data_de_exclusao = Time.now
    Pagamento.transaction do
      cheques = @pagamento.cheques
      cheques.each() do |cheque|
        cheque.pagamento_id = nil
        cheque.save
      end
      @pagamento.save
    end

    respond_to do |format|
      format.html { redirect_to(pagamentos_url) }
      format.xml  { head :ok }
    end
  end
  
   def relatorio
     @tipos_pagamento = TipoPagamento.da_clinica(session[:clinica_id]).por_nome.collect{|obj| [obj.nome, obj.id.to_s]}
     if params[:datepicker]
       @data_inicial = params[:datepicker].to_date
       @data_final = params[:datepicker2].to_date
     else
       @data_inicial = Date.today  - Date.today.day + 1.day
       @data_final = Date.today
     end
     @pagamentos = Pagamento.da_clinica(session[:clinica_id]).nao_excluidos.por_data.entre_datas(@data_inicial, @data_final).tipos(params[:tipo_pagamento_id])
     respond_to do |format|
       format.html # index.html.erb
       format.xml  { render :xml => @pagamentos }
     end
   end
   
end
