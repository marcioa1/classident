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
  end

  def update
    @cheque = Cheque.find(params[:id])
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
      redirect_to(:back) 
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
    #TODO falta colocar fitro de clínica
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
    if !administracao
      @status << ["administração","administração"]
    end
    @cheques = []
    if params[:status] == "todos"
      if administracao
        @cheques = Cheque.por_bom_para.na_administracao.
               entre_datas(@data_inicial,@data_final).nao_excluidos
      else
        @cheques = Cheque.por_bom_para.da_clinica(session[:clinica_id]).
               entre_datas(@data_inicial,@data_final).nao_excluidos
      end
    end
    if params[:status] == "disponíveis"
      if administracao
        @cheques = Cheque.por_bom_para.entre_datas(@data_inicial,@data_final).
              disponiveis_na_administracao.nao_excluidos
      else
        @cheques = Cheque.por_bom_para.da_clinica(session[:clinica_id]).entre_datas(@data_inicial,@data_final).
              disponiveis_na_clinica.nao_excluidos
      end
    end
    if params[:status]== "devolvido 2 vezes"
      @cheques = Cheque.por_bom_para.da_clinica(session[:clinica_id]).entre_datas(@data_inicial,@data_final).
              devolvido_duas_vezes.nao_excluidos
    end 
    if params[:status]=="administração"     
      if administracao
        @cheques = Cheque.por_bom_para.na_administracao.entre_datas(@data_inicial,@data_final).
              entregues_a_administracao.nao_excluidos
      else
        @cheques = Cheque.por_bom_para.da_clinica(session[:clinica_id]).entre_datas(@data_inicial,@data_final).
              entregues_a_administracao.nao_excluidos
      end
    end
    if params[:status]=="usados para pagamento"
      @cheques = Cheque.por_bom_para.da_clinica(session[:clinica_id]).entre_datas(@data_inicial,@data_final).
              usados_para_pagamento
    end  
    if params[:status]=="destinação"
      @cheques = Cheque.por_bom_para.da_clinica(session[:clinica_id]).entre_datas(@data_inicial,@data_final).com_destinacao
    end  
    if params[:status]=="devolvido"
      @cheques = Cheque.por_bom_para.da_clinica(session[:clinica_id]).devolvidos(@data_inicial,@data_final)
    end
    if params[:status]=="reapresentado"
      @cheques = Cheque.por_bom_para.da_clinica(session[:clinica_id]).reapresentados(@data_inicial,@data_final)
    end
    if params[:status]=="spc"
      @cheques = Cheque.por_bom_para.da_clinica(session[:clinica_id]).spc(@data_inicial,@data_final)
    end
    if @administracao
      clinicas_selecionadas = ""
      @clinicas.each do |clinica|
        clinicas_selecionadas += clinica.id.to_s + "," if params["clinica_#{clinica.id}".to_sym]
      end
      @cheques = @cheques.vindo_da_clinica(clinicas_selecionadas[0..-2]) if clinicas_selecionadas.size>1
    end
     #TODO fazer parametros que faltam de situação de cheque
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
      @cheques = Cheque.na_administracao.do_banco(params[:banco])
    else 
      @cheques = Cheque.da_clinica(session[:clinica_id]).do_banco(params[:banco])
    end
    if params[:agencia] && !params[:agencia].blank?
      @cheques = @cheques.da_agencia(params[:agencia])
    end
    @cheques = @cheques.do_valor(params[:valor].gsub(",",".")) if !params[:valor].blank?
    
  end
end
