class ChequesController < ApplicationController

  layout "adm", :except => :show
  
  before_filter :require_user
  before_filter :salva_action_na_session
  before_filter :verifica_se_tem_senha


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
    # if params[:datepicker4].empty?
    #      @cheque.data_segunda_devolucao = nil
    #    else
    #      @cheque.data_segunda_devolucao = params[:datepicker4].to_date
    #    end
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
    params[:ordem] = 'por_data' if params[:ordem].nil?
    session[:origem] = cheques_recebidos_cheques_path
    @clinicas = Clinica.todas.por_nome if @clinica_atual.administracao?
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
        ["reapresentado","reapresentado"], ["spc", "spc"], ["solucionado", "solucionado"]].sort!
    # if !administracao
      @status << ["enviados à administração","enviados à administração"]
      @status << ["recebidos pela administração", "recebidos pela administração"]
      @status << ["devolvidos à clínica", "devolvidos à clínica"]
      @status << ["recebidos pela clínica", "recebidos pela clínica"]
    # end
    @cheques = []
    if @clinica_atual.administracao?
      selecionadas = []
      @clinicas.each do |clinica|
        selecionadas << clinica.id if params["clinica_#{clinica.id}".to_sym]
      end
      case
        when params[:status] == 'todos' 
          @cheques = Cheque.na_administracao.entre_datas(@data_inicial,@data_final).
            nao_excluidos.das_clinicas(selecionadas).ordenado_por(params[:ordem])
        when params[:status] == 'disponíveis'
          @cheques = Cheque.entre_datas(@data_inicial,@data_final).
            disponiveis_na_administracao.nao_excluidos.das_clinicas(selecionadas).ordenado_por(params[:ordem])
        when params[:status] == 'devolvido 2 vezes' 
          @cheques = Cheque.devolvido_duas_vezes_entre_datas(@data_inicial,@data_final).
                     nao_excluidos.das_clinicas(selecionadas).ordenado_por(params[:ordem])
        when params[:status] == 'enviados à administração' 
          @cheques = Cheque.enviados_a_administracao(@data_inicial,@data_final).
            nao_recebidos.nao_excluidos.das_clinicas(selecionadas).ordenado_por(params[:ordem])
        when params[:status] == 'recebidos pela administração'
          @cheques = Cheque.entre_datas(@data_inicial,@data_final).
            na_administracao.nao_excluidos.das_clinicas(selecionadas).ordenado_por(params[:ordem])
        when params[:status] == 'usados para pagamento'
          @cheques = Cheque.entre_datas(@data_inicial,@data_final).
            na_administracao.usados_para_pagamento.das_clinicas(selecionadas).ordenado_por(params[:ordem])
        when params[:status] == 'devolvido' 
          @cheques = Cheque.na_administracao.devolvidos(@data_inicial,@data_final).
            das_clinicas(selecionadas).ordenado_por(params[:ordem])
        when params[:status] == 'destinação'
          @cheques = Cheque.na_administracao.entre_datas(@data_inicial,@data_final).com_destinacao.
            das_clinicas(selecionadas).ordenado_por(params[:ordem])
        when params[:status] == 'reapresentado'
          @cheques = Cheque.na_administracao.reapresentados(@data_inicial,@data_final).
            das_clinicas(selecionadas).ordenado_por(params[:ordem])
        when params[:status]=="spc"
          @cheques = Cheque.na_administracao.spc(@data_inicial,@data_final).
            das_clinicas(selecionadas).ordenado_por(params[:ordem])
        when params[:status]=="solucionado" 
          @cheques = Cheque.na_administracao.solucionado(@data_inicial,@data_final).
            das_clinicas(selecionadas).ordenado_por(params[:ordem])
        when params[:status]=="devolvidos à clínica"
          @cheques = Cheque.devolvidos_a_clinica_entre_datas(@data_inicial,@data_final).
            das_clinicas(selecionadas).ordenado_por(params[:ordem])
        when params[:status]=="recebidos pela clínica"
          @cheques = Cheque.recebidos_pela_clinica_entre_datas(@data_inicial,@data_final).
            das_clinicas(selecionadas).ordenado_por(params[:ordem])
      end
    else
      case
        when params[:status] == 'todos' 
          @cheques = Cheque.da_clinica(session[:clinica_id]).
            entre_datas(@data_inicial,@data_final).nao_excluidos.ordenado_por(params[:ordem])
        when params[:status] == 'disponíveis' 
          @cheques = Cheque.da_clinica(session[:clinica_id]).entre_datas(@data_inicial,@data_final).
            disponiveis_na_clinica.nao_excluidos.ordenado_por(params[:ordem])
        when params[:status] == 'devolvido 2 vezes' 
          @cheques = Cheque.da_clinica(session[:clinica_id]).entre_datas(@data_inicial,@data_final).
            devolvido_duas_vezes.nao_excluidos.ordenado_por(params[:ordem])
        when params[:status] == 'enviados à administração' 
          @cheques = Cheque.da_clinica(session[:clinica_id]).enviados_a_administracao(@data_inicial,@data_final).
            nao_recebidos.nao_excluidos.ordenado_por(params[:ordem])
        when params[:status] == 'recebidos pela administração' 
          @cheques = Cheque.da_clinica(session[:clinica_id]).entre_datas(@data_inicial,@data_final).
            na_administracao.nao_excluidos.ordenado_por(params[:ordem])
        when params[:status] == 'usados para pagamento' 
          @cheques = Cheque.entre_datas(@data_inicial,@data_final).
            da_clinica(session[:clinica_id]).usados_para_pagamento.ordenado_por(params[:ordem])
        when params[:status] == 'devolvido' 
          @cheques = Cheque.da_clinica(session[:clinica_id]).devolvidos(@data_inicial,@data_final).ordenado_por(params[:ordem])
        when params[:status] == 'destinação' 
          @cheques = Cheque.da_clinica(session[:clinica_id]).entre_datas(@data_inicial,@data_final).com_destinacao.ordenado_por(params[:ordem])
        when params[:status] == 'reapresentado' 
          @cheques = Cheque.da_clinica(session[:clinica_id]).reapresentados(@data_inicial,@data_final).ordenado_por(params[:ordem])
        when params[:status]=="spc" 
          @cheques = Cheque.da_clinica(session[:clinica_id]).spc(@data_inicial,@data_final).ordenado_por(params[:ordem])
        when params[:status]=="recebidos pela clínica" 
          @cheques = Cheque.da_clinica(session[:clinica_id]).recebidos_pela_clinica_entre_datas(@data_inicial,@data_final).ordenado_por(params[:ordem])
        when params[:status]=="devolvidos à clínica"
          @cheques = Cheque.devolvidos_a_clinica_entre_datas(@data_inicial,@data_final).
            da_clinica(session[:clinica_id]).ordenado_por(params[:ordem])
        when params[:status]=="recebidos pela clínica"
          @cheques = Cheque.recebidos_pela_clinica_entre_datas(@data_inicial,@data_final).
            da_clinica(session[:clinica_id]).ordenado_por(params[:ordem])
      end
    end
    @titulo = "Lista de cheques entre #{@data_inicial.to_s_br}e #{@data_final.to_s_br} , #{params[:status]}"
  end
  
  def envia_cheques_a_administracao
    lista = params[:cheques].split(",")
    lista.each() do |numero|
      id      = numero.split("_")
      cheque  = Cheque.find(id[1].to_i)
      cheque.envia_a_administracao
    end
    render :json => (lista.size.to_s  + " cheques recebidos.").to_json
  end

  def confirma_recebimento
    if params[:ordem] == 'data'
      @cheques  = Cheque.vindo_da_clinica(params[:clinica]).entregues_a_administracao.nao_recebidos.por_bom_para
    else
      @cheques  = Cheque.vindo_da_clinica(params[:clinica]).entregues_a_administracao.nao_recebidos.por_valor
    end
    @clinicas = Clinica.todas 
  end
  
  def registra_recebimento_de_cheques
    lista = params[:cheques].split(",")
    lista.each() do |numero|
      cheque = Cheque.find(numero.to_i)
      cheque.confirma_recebimento_na_administracao
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
    valor = params[:valor].gsub('.', '').gsub(',','.')
    if @clinica_atual.administracao?
      @cheques = Cheque.disponiveis_na_administracao.por_valor.menores_ou_igual_a(valor).entre_datas(Date.new(2011,01,01),Date.today);
    else
      @cheques = Cheque.da_clinica(session[:clinica_id]).disponiveis_na_clinica.por_valor.menores_ou_igual_a(valor).entre_datas(Date.new(2011,01,01),Date.today);
    end
    @cheques = @cheques.all(:limit => 11150)
    render :partial => 'cheques_disponiveis', :locals=>{:cheques => @cheques}
  end
  
  def pesquisa
    @bancos = Banco.por_nome.collect{|obj| [obj.numero.to_s + '-'+ obj.nome, obj.id.to_s]}
    @cheques = []
    # params[:ano] = Date.today.year if !params[:ano]
    if params[:agencia].present? || params[:numero].present? || params[:valor].present? then
      
      if @clinica_atual.administracao?
        if params[:banco] && !params[:banco].blank?
          @cheques = Cheque.na_administracao.do_banco(params[:banco])#.entre_datas(data_inicial, data_final)
        else
          @cheques = Cheque.na_administracao#.entre_datas(data_inicial, data_final)
        end
      else 
        if params[:banco] && !params[:banco].blank?
          @cheques = Cheque.da_clinica(session[:clinica_id]).do_banco(params[:banco])#.entre_datas(data_inicial, data_final)
        else
          @cheques = Cheque.da_clinica(session[:clinica_id])#.entre_datas(data_inicial, data_final)
        end
      end
      if params[:ano].present?
        data_inicial = params[:ano].to_s + '-01-01'
        data_final   = params[:ano].to_s + '-12-31'
        @cheques = @cheques.entre_datas(data_inicial, data_final)
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
  
  def confirma_recebimento_na_administracao
    cheque = Cheque.find(params[:id])
    cheque.confirma_recebimento_na_administracao
    head :ok
  end

  def reverte_cheque
    cheque = Cheque.find(params[:id])
    cheque.update_attribute(:data_entrega_administracao, nil)
    head :ok
  end

  def devolve_a_clinica
    cheque = Cheque.find(params[:id])
    cheque.devolve_a_clinica
    head :ok
  end

  def recebe_da_administracao
    cheque = Cheque.find(params[:id])
    cheque.update_attribute(:data_recebido_da_administracao, Date.today)
    head :ok
  end  
  
end
