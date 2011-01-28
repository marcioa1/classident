class ChequesController < ApplicationController

  layout "adm", :except => :show
  
  before_filter :require_user

  def index
    @cheques = Cheque.all

  end

  def show
    @cheque = Cheque.find(params[:id])
  end

  def edit
    @bancos = Banco.all(:order=>:nome).collect{|obj| [obj.nome,obj.id]}
    @cheque = Cheque.find(params[:id])
    session[:origem] = edit_cheque_path(@cheque)
  end

  def update
    @cheque = Cheque.find(params[:id])
    valor_anterior = @cheque.valor
    if params[:datepicker2].empty?
      @cheque.data_primeira_devolucao = nil
    else
      @cheque.data_primeira_devolucao = params[:datepicker2].to_date
    end
    if params[:datepicker3].empty?
      @cheque.data_reapresentacao = nil
    else
      @cheque.data_reapresentacao = params[:datepicker3].to_date
    end
    if params[:datepicker4].empty?
      @cheque.data_segunda_devolucao = nil
    else
      @cheque.data_segunda_devolucao = params[:datepicker4].to_date
    end

    if @cheque.update_attributes(params[:cheque])
      if valor_anterior != @cheque.valor
        @cheque.recebimentos.first.update_attribute(:valor, @cheque.valor)
      end
      redirect_to( session[:origem] ) 
    else
      render :action => "edit" 
    end
  end

  def destroy
    @cheque = Cheque.find(params[:id])
    @cheque.destroy

    redirect_to(cheques_url) 
  end
  
  def cheques_recebidos
    session[:origem] = cheques_recebidos_cheques_path
    @clinicas = Clinica.todas.por_nome if @administracao
    if params[:datepicker] && Date.valid?(params[:datepicker])
      @data_inicial = params[:datepicker].to_date
    else
      @data_inicial = Date.today - Date.today.day.days + 1.day
    end
    if params[:datepicker2] && Date.valid?(params[:datepicker2])
      @data_final = params[:datepicker2].to_date
    else
      @data_final = Date.today
    end
    @status = [["todos","todos"],["disponíveis","disponíveis"],
        ["devolvido 2 vezes","devolvido 2 vezes"],
        ["usados para pagamento","usados para pagamento"],
        ["destinação", "destinação"], ["devolvido","devolvido"],
        ["reapresentado","reapresentado"], ["spc", "spc"]].sort!
    # if !administracao
      @status << ["enviados à administração","enviados à administração"]
      @status << ["recebidos pela administração", "recebidos pela administração"]
    # end
    @cheques = []
    if @administracao
      selecionadas = []
      @clinicas.each do |clinica|
        selecionadas << clinica.id if params["clinica_#{clinica.id}".to_sym]
      end
      # raise selecionadas.inspect
      case
        when params[:status] == 'todos'
          @cheques = Cheque.por_bom_para.na_administracao.
            entre_datas(@data_inicial,@data_final).nao_excluidos.das_clinicas(selecionadas)
        when params[:status] == 'disponíveis'
          @cheques = Cheque.por_bom_para.entre_datas(@data_inicial,@data_final).
            disponiveis_na_administracao.nao_excluidos.das_clinicas(selecionadas)
        when params[:status] == 'devolvido 2 vezes'
          @cheques = Cheque.por_bom_para.da_clinica(session[:clinica_id]).entre_datas(@data_inicial,@data_final).
            devolvido_duas_vezes.nao_excluidos.das_clinicas(selecionadas)
        when params[:status] == 'enviados à administração'
          @cheques = Cheque.por_bom_para.entre_datas(@data_inicial,@data_final).
            entregues_a_administracao.nao_recebidos.nao_excluidos.das_clinicas(selecionadas)
        when params[:status] == 'recebidos pela administração'
          @cheques = Cheque.por_bom_para.entre_datas(@data_inicial,@data_final).
            na_administracao.nao_excluidos.das_clinicas(selecionadas)
        when params[:status] == 'usados para pagamento'
          @cheques = Cheque.por_bom_para.entre_datas(@data_inicial,@data_final).
            na_administracao.usados_para_pagamento.das_clinicas(selecionadas)
        when params[:status] == 'devolvido'
          @cheques = Cheque.na_administracao.por_bom_para.devolvidos(@data_inicial,@data_final).
            das_clinicas(selecionadas)
        when params[:status] == 'destinação'
          @cheques = Cheque.por_bom_para.na_administracao.entre_datas(@data_inicial,@data_final).com_destinacao.
            das_clinicas(selecionadas)
        when params[:status] == 'reapresentado'
          @cheques = Cheque.por_bom_para.na_administracao.reapresentados(@data_inicial,@data_final).
            das_clinicas(selecionadas)
        when params[:status]=="spc"
          @cheques = Cheque.por_bom_para.na_administracao.spc(@data_inicial,@data_final).
            das_clinicas(selecionadas)
      end
    else
      case
        when params[:status] == 'todos'
          @cheques = Cheque.por_bom_para.da_clinica(session[:clinica_id]).
            entre_datas(@data_inicial,@data_final).nao_excluidos
        when params[:status] == 'disponíveis'
          @cheques = Cheque.por_bom_para.da_clinica(session[:clinica_id]).entre_datas(@data_inicial,@data_final).
            disponiveis_na_clinica.nao_excluidos
        when params[:status] == 'devolvido 2 vezes'
          @cheques = Cheque.por_bom_para.da_clinica(session[:clinica_id]).entre_datas(@data_inicial,@data_final).
            devolvido_duas_vezes.nao_excluidos
        when params[:status] == 'enviados à administração'
          @cheques = Cheque.por_bom_para.da_clinica(session[:clinica_id]).entre_datas(@data_inicial,@data_final).
            entregues_a_administracao.nao_recebidos.nao_excluidos
        when params[:status] == 'recebidos pela administração'
          @cheques = Cheque.por_bom_para.da_clinica(session[:clinica_id]).entre_datas(@data_inicial,@data_final).
            na_administracao.nao_excluidos
        when params[:status] == 'usados para pagamento'
          @cheques = Cheque.por_bom_para.entre_datas(@data_inicial,@data_final).
            da_clinica(session[:clinica_id]).usados_para_pagamento
        when params[:status] == 'devolvido'
          @cheques = Cheque.da_clinica(session[:clinica_id]).por_bom_para.devolvidos(@data_inicial,@data_final)
        when params[:status] == 'destinação'
          @cheques = Cheque.por_bom_para.da_clinica(session[:clinica_id]).entre_datas(@data_inicial,@data_final).com_destinacao
        when params[:status] == 'reapresentado'
          @cheques = Cheque.por_bom_para.da_clinica(session[:clinica_id]).reapresentados(@data_inicial,@data_final)
        when params[:status]=="spc"
          @cheques = Cheque.por_bom_para.da_clinica(session[:clinica_id]).spc(@data_inicial,@data_final)
      end
    end
  end
  
  def recebe_cheques
    lista = params[:cheques].split(",")
    lista.each() do |numero|
      id      = numero.split("_")
      cheque  = Cheque.find(id[1].to_i)
      cheque.data_entrega_administracao =  Date.today
      cheque.save
    end
    render :json => (lista.size.to_s  + " cheques recebidos.").to_json
  end

  def confirma_recebimento
    @cheques  = Cheque.vindo_da_clinica(params[:clinica]).entregues_a_administracao.nao_recebidos
    @clinicas = Clinica.todas 
  end
  
  def registra_recebimento_de_cheques
    lista = params[:cheques].split(",")
    lista.each() do |numero|
      cheque = Cheque.find(numero.to_i)
      cheque.data_recebimento_na_administracao = Date.today
      cheque.save
    end
    render :json => (lista.size.to_s  + " cheques recebidos.").to_json
  end
  
  def recebimento_confirmado
    if params[:datepicker]
      @inicio = params[:datepicker].to_date
      @fim = params[:datepicker2].to_date
      @cheques = Cheque.recebidos_na_administracao(params[:datepicker].to_date,
                     params[:datepicker2].to_date)
   else
     @inicio = Date.today - 15.days
     @fim = Date.today
      @cheques = []
    end
  end
  
  def busca_disponiveis
    if @administracao
      @cheques = Cheque.disponiveis_na_administracao.por_valor.menores_que(params[:valor]);
    else
      @cheques = Cheque.da_clinica(session[:clinica_id]).disponiveis_na_clinica.por_valor.menores_ou_igual_a(params[:valor]);
    end
    @cheques = @cheques.all(:limit => 50)
    render :partial => 'cheques_disponiveis', :locals=>{:cheques => @cheques}
  end
  
  def pesquisa
    @bancos = Banco.por_nome.collect{|obj| [obj.nome, obj.id.to_s]}
    if @administracao
      if params[:banco] && !params[:banco].blank?
        @cheques = Cheque.na_administracao.do_banco(params[:banco])
      else
        @cheques = Cheque.na_administracao
      end
    else 
      if params[:banco] && !params[:banco].blank?
        @cheques = Cheque.da_clinica(session[:clinica_id]).do_banco(params[:banco])
      else
        @cheques = Cheque.da_clinica(session[:clinica_id])
      end
    end
    if params[:agencia] && !params[:agencia].blank?
      @cheques = @cheques.da_agencia(params[:agencia])
    end
    if params[:numero] && !params[:numero].blank?
      @cheques = @cheques.com_numero(params[:numero])
    end
    @cheques = @cheques.do_valor(params[:valor].gsub(",",".")) if !params[:valor].blank?
    
  end
end
