class PagamentosController < ApplicationController
  
  layout "adm" , :except=> :show
  
  before_filter :require_user
  before_filter :salva_action_na_session
  before_filter :verifica_se_tem_senha

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
    @pagamento       = Pagamento.new(:data_de_pagamento => Date.today)
    if params[:valor]
      @pagamento.valor_pago = params[:valor]
    end
    @contas_bancarias = ContaBancaria.all.collect{|obj| [obj.nome, obj.id]}.insert(0,'')
  end

  def edit
    @tipos_pagamento  = TipoPagamento.ativos.por_nome.collect{|obj| [obj.nome, obj.id]}
    @pagamento        = Pagamento.find(params[:id])
    @contas_bancarias = ContaBancaria.all.collect{|obj| [obj.nome, obj.id]}.insert(0,'')
    @ids_cheques = @pagamento.cheques.map(&:id).join(",")
  end

  def create
    @pagamento                   = Pagamento.new(params[:pagamento])
    @pagamento.clinica_id        = session[:clinica_id]
    @pagamento.protetico_id      = session[:protetico_id] unless session[:protetico_id].nil?
    @pagamento.dentista_id       = session[:dentista_id] unless session[:dentista_id].nil?
    Pagamento.transaction do
      ids = params[:cheques_ids].split(",")
      total_cheque = 0.0
      ids.each do |id|
        cheque = Cheque.find(id)
        @pagamento.cheques << cheque unless cheque.nil?
        total_cheque += cheque.valor
      end
      @pagamento.valor_terceiros = total_cheque
      if @pagamento.save
        @pagamento.verifica_fluxo_de_caixa
        if !session[:trabalho_protetico_id].nil?
          ids = session[:trabalho_protetico_id].split(",")
          ids.each do |id|
            trab              = TrabalhoProtetico.find(id)
            trab.pagamento_id = @pagamento.id
            trab.save
          end
        end
        if params[:dentista_id]
          dentista = Dentista.find(params[:dentista_id])
          #FIXME Verificar se em cada clinica paga o valor correto
          dentista.clinicas.each do |cli|
            Pagamento.create(:clinica_id=>cli.id, :data_de_pagamento=>@pagamento.data_de_pagamento,
               :pagamento_id=>@pagamento.id, :valor_pago=>params['valor_'+ cli.id.to_s ], :tipo_pagamento_id=>@pagamento.tipo_pagamento_id,
               :observacao=>'pago pela adm', :nao_lancar_no_livro_caixa=>true)
          end
        end
        flash[:notice] = 'Pagamento criado com sucesso.'
        redirect_to(session[:origem] || relatorio_pagamentos_path) #TODO retornar para tela anterio
      else
        @tipos_pagamento  = TipoPagamento.da_clinica(session[:clinica_id]).ativos.por_nome.collect{|obj| [obj.nome, obj.id]}
        @contas_bancarias = ContaBancaria.all.collect{|obj| [obj.nome, obj.id]}.insert(0,'')

        render :action => "new" 
      end
    end
  end

  def update
    @pagamento = Pagamento.find(params[:id])

    if @pagamento.update_attributes(params[:pagamento])
      cheques_anteriores = @pagamento.cheques.map(&:id)
      ids = params[:cheques_ids].split(",")
      # retira os cheques usados num primeiro pagamento que nõa fazer 
      # mais parte deste pagamento para torná-los disponíveis novamente
      (cheques_anteriores - ids).each do |chq|
        cheque = Cheque.find(chq)
        cheque.update_attribute(:pagamento_id, nil)
      end
        
      total_cheque = 0.0
      @pagamento.cheques = []
      ids.each do |id|
        cheque = Cheque.find(id)
        @pagamento.cheques << cheque unless cheque.nil?
        total_cheque += cheque.valor
      end
      @pagamento.valor_terceiros = total_cheque
      @pagamento.save
      Alteracoe.retira_permissao_de_alteracao('pagamentos', @pagamento.id, current_user.id) if !@pagamento.na_quinzena?
      
      @pagamento.verifica_fluxo_de_caixa
      flash[:notice] = 'Pagamento alterado com sucesso.'
      redirect_to(session[:origem] || relatorio_pagamentos_path) 
    else
      render :action => "edit" 
    end
  end

  def exclui 
    @pagamento                     = Pagamento.find(params[:id])
    @pagamento.observacao_exclusao = params[:observacao_exclusao]
    @pagamento.data_de_exclusao    = Time.current
    @pagamento.usuario_exclusao    = current_user.id
    @pagamento.verifica_fluxo_de_caixa
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
    Alteracoe.retira_permissao_de_alteracao('pagamentos', @pagamento.id, current_user.id) if !@pagamento.na_quinzena?
    redirect_to(session[:origem] || relatorio_pagamentos_path) 
  end
  
  def relatorio
    # raise params.inspect
    params[:livro_caixa] = 'ambos' if params[:livro_caixa].nil?
    params[:modo] = 'todos' if params[:modo].nil?
    session[:origem] = '/pagamentos/relatorio'
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
    @titulo = "Pagamento entre #{@data_inicial.to_s_br} e #{@data_final.to_s_br} "

    if params[:modo] != 'todos'
      if params[:modo] == 'dinheiro'
        @pagamentos = @pagamentos.em_dinheiro 
        @titulo+= " em dinheiro"
      elsif params[:modo] == 'cheque classident'
        @pagamentos = @pagamentos.com_cheque_da_classident
        @titulo += "em cheque da classident"
      elsif params[:modo] == 'cheque paciente'
        @pagamentos = @pagamentos.com_cheque_de_paciente 
        @titulo += " com cheque de paciente"
      end
    end
    if params[:livro_caixa] == 'sim'
      @pagamentos = @pagamentos.no_livro_caixa
      @titulo += " no livro caixa"
    elsif params[:livro_caixa] == 'não'
      @pagamentos = @pagamentos.fora_do_livro_caixa
      @titulo += " fora do livro caixa"
    end
    if params[:pela_adm]
      @pela_administracao = Pagamento.pela_administracao.entre_datas(@data_inicial, @data_final).da_clinica(session[:clinica_id])
      @pagamentos += @pela_administracao
      @titulo += " pela adm"
    end
    # raise params[:livro_caixa].inspect
  end
   
  def registra_pagamento_a_protetico
    valores = params[:valores].split(';')
    total   = 0.0
    valores.each do |v| 
      total += v.gsub('.', '').sub(',','.').to_f
    end
    session[:protetico_id]          = params[:protetico_id]
    session[:trabalho_protetico_id] = params[:ids]  
    session[:valor]                 = total
    redirect_to new_pagamento_path(:protetico_id=>params[:protetico_id], 
         :trabalho_protetico_id=>params[:ids], :valor=>total )
  end
  
  def exclusao
    @pagamento = Pagamento.find(params[:id])
  end
  
  def pagamentos_de_hoje
    session[:origem] = '/pagamentos/pagamentos_de_hoje'
    @pagamentos_no_livro_caixa      = Pagamento.da_clinica(session[:clinica_id]).no_dia(Date.today).no_livro_caixa.nao_excluidos
    @pagamentos_fora_do_livro_caixa = Pagamento.da_clinica(session[:clinica_id]).no_dia(Date.today).fora_do_livro_caixa.nao_excluidos
  end
  
end
