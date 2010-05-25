class PagamentosController < ApplicationController
  
  layout "adm" , :except=> :show
  before_filter :require_user

  def index
    @pagamentos = Pagamento.all
  end

  def show
    @pagamento = Pagamento.find(params[:id])
  end

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
    if !params[:dentista_id].blank?
      session[:dentista_id] = params[:dentista_id]
      @dentista = Dentista.find(params[:dentista_id])
    else
      session[:dentista_id] = nil
    end
    @tipos_pagamento = TipoPagamento.da_clinica(session[:clinica_id]).ativos.por_nome.collect{|obj| [obj.nome, obj.id]}
    @pagamento = Pagamento.new
    if params[:valor]
      @pagamento.valor = params[:valor]
    end
    @contas_bancarias = ContaBancaria.all.collect{|obj| [obj.nome, obj.id]}
  end

  def edit
    @tipos_pagamento  = TipoPagamento.por_nome.collect{|obj| [obj.nome, obj.id]}
    @pagamento        = Pagamento.find(params[:id])
    @contas_bancarias = ContaBancaria.all.collect{|obj| [obj.nome, obj.id]}
  end

  def create
    @pagamento = Pagamento.new(params[:pagamento])
    @pagamento.data_de_pagamento = params[:datepicker].to_date
    @pagamento.clinica_id = session[:clinica_id]
    if params[:opcao_restante]!="pago_em_cheque"
      @pagamento.conta_bancaria_id = nil
    end
    @pagamento.protetico_id = session[:protetico_id] unless session[:protetico_id].nil?
    @pagamento.dentista_id = session[:dentista_id] unless session[:dentista_id].nil?
    Pagamento.transaction do
      ids = params[:cheques_ids].split(",")
      ids.each do |id|
        cheque = Cheque.find(id)
        @pagamento.cheques << cheque unless cheque.nil?
      end
      if @pagamento.save
        if !session[:trabalho_protetico_id].nil?
          ids = session[:trabalho_protetico_id].split(",")
          ids.each do |id|
            trab = TrabalhoProtetico.find(id)
            trab.pagamento_id = @pagamento.id
            trab.save
          end
        end
        if params[:dentista_id]
          dentista = Dentista.find(params[:dentista_id])
          dentista.clinicas.each do |cli|
            Pagamento.create(:clinica_id=>cli.id, :data_de_pagamento=>@pagamento.data_de_pagamento,
               :pagamento_id=>@pagamento.id, :valor_pago=>params['valor_'+ cli.id.to_s ], :tipo_pagamento_id=>@pagamento.tipo_pagamento_id,
               :observacao=>'pago pela adm', :nao_lancar_no_livro_caixa=>true)
          end
        end
        flash[:notice] = 'Pagamento criado com sucesso.'
        redirect_to(relatorio_pagamentos_path) #TODO retornar para tela anterio
      else
        render :action => "new" 
      end
    end
  end

  def update
    @pagamento = Pagamento.find(params[:id])

    if @pagamento.update_attributes(params[:pagamento])
      flash[:notice] = 'Pagamento alterado com sucesso.'
      redirect_to(relatorio_pagamentos_path) 
    else
      render :action => "edit" 
    end
  end

  def destroy
    @pagamento = Pagamento.find(params[:id])
    @pagamento.data_de_exclusao = Time.now
    Pagamento.transaction do
      cheques = @pagamento.cheques
      cheques.each() do |cheque|
        cheque.pagamento_id = nil
        cheque.save
      end
      @pagamento.trabalho_proteticos.each do |trab|
        trab.pagamento_id = -1
        trab.save
      end
      @pagamento.save
    end

    redirect_to(relatorio_pagamentos_path) 
  end
  
   def relatorio
     @tipos_pagamento = TipoPagamento.da_clinica(session[:clinica_id]).por_nome.collect{|obj| [obj.nome, obj.id.to_s]}
     if params[:datepicker] && Date.valid?(params[:datepicker])
       @data_inicial = params[:datepicker].to_date 
    else
      @data_inicial = Date.today  - Date.today.day + 1.day
    end
    if params[:datepicker2] && Date.valid?(params[:datepicker2])
      @data_final   = params[:datepicker2].to_date  
    else
      @data_final   = Date.today
    end
    @pagamentos = Pagamento.da_clinica(session[:clinica_id]).nao_excluidos.por_data.entre_datas(@data_inicial, @data_final).tipos(params[:tipo_pagamento_id])
    if params[:pela_adm]
      @pela_administracao = Pagamento.pela_administracao.entre_datas(@data_inicial, @data_final).da_clinica(session[:clinica_id])
      @pagamentos += @pela_administracao
    end
  end
   
end
