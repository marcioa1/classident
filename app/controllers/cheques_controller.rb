class ChequesController < ApplicationController

  layout "adm", :except => :show
  
  before_filter :require_user
  # GET /cheques
  # GET /cheques.xml
  def index
    @cheques = Cheque.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cheques }
    end
  end

  # GET /cheques/1
  # GET /cheques/1.xml
  def show
    @cheque = Cheque.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cheque }
    end
  end

  # GET /cheques/1/edit
  def edit
    @bancos = Banco.all(:order=>:nome).collect{|obj| [obj.numero + " - " + obj.nome,obj.id]}
    @cheque = Cheque.find(params[:id])
  end

  # PUT /cheques/1
  # PUT /cheques/1.xml
  def update
    @cheque = Cheque.find(params[:id])
    debugger
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
    respond_to do |format|
      if @cheque.update_attributes(params[:cheque])
        format.html { redirect_to(:back) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cheque.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cheques/1
  # DELETE /cheques/1.xml
  def destroy
    @cheque = Cheque.find(params[:id])
    @cheque.destroy

    respond_to do |format|
      format.html { redirect_to(cheques_url) }
      format.xml  { head :ok }
    end
  end
  
  def cheques_recebidos
    if params[:datepicker]
      @data_inicial = params[:datepicker].to_date
      @data_final = params[:datepicker2].to_date
    else
      @data_inicial = Date.today - Date.today.day.days + 1.day
      @data_final = Date.today
    end
    @status = [["todos","todos"],["disponíveis","disponíveis"],
        ["devolvido 2 vezes","devolvido 2 vezes"],
        ["administração","administração"],
        ["usados para pagamento","usados para pagamento"]]
    debugger
    @cheques = []
    if params[:status] == "todos"
      @cheques = Cheque.por_bom_para.da_clinica(session[:clinica_id]).entre_datas(@data_inicial,@data_final)
    end
    if params[:status] == "disponíveis"
      @cheques = Cheque.por_bom_para.da_clinica(session[:clinica_id]).entre_datas(@data_inicial,@data_final).disponiveis
    end
    if params[:status]== "devolvido 2 vezes"
      @cheques = Cheque.por_bom_para.da_clinica(session[:clinica_id]).entre_datas(@data_inicial,@data_final).devolvido_duas_vezes
    end 
    if params[:status]=="administração"     
      @cheques = Cheque.por_bom_para.da_clinica(session[:clinica_id]).entre_datas(@data_inicial,@data_final).entregues_a_administracao
    end
    if params[:status]=="usados para pagamento"
      @cheques = Cheque.por_bom_para.da_clinica(session[:clinica_id]).entre_datas(@data_inicial,@data_final).usados_para_pagamento
    end  
     #TODO fazer parametros que faltam de situação de cheque
  end
  
  def recebe_cheques
    lista = params[:cheques].split(",")
    lista.each() do |numero|
      id = numero.split("_")
      cheque = Cheque.find(id[1].to_i)
      cheque.data_entrega_administracao = Date.today
      cheque.save
    end
    render :json => (lista.size.to_s  + " cheques recebidos.").to_json
  end

  def confirma_recebimento
    @cheques = Cheque.entregues_a_administracao.nao_recebidos
  end
  
  def registra_recebimento_de_cheques
    debugger
    lista = params[:cheques].split(",")
    lista.each() do |numero|
      cheque = Cheque.find(numero.to_i)
      cheque.data_recebimento_na_administracao = Date.today
      cheque.save
    end
    render :json => (lista.size.to_s  + " cheques recebidos.").to_json
  end
  
  def recebimento_confirmado
     @cheques = Cheque.recebidos_na_administracao
  end
  
  def busca_disponiveis
    @cheques = Cheque.disponiveis.por_valor.menores_que(params[:valor]);
    result = "<table >"
    result += "<tr><th>Bom para</th><th>valor</th><th>Paciente</th><th>&nbsp;</th></tr>"
    @cheques.each() do |cheque|
      result +=  "<tr><td>" + cheque.bom_para.to_s_br + "</td>" 
      result += "<td><span id='valor_#{cheque.id}'>" + cheque.valor.real.to_s + "</span></td>"
      result += "<td>" + cheque.sequencial.to_s + cheque.recebimento.paciente.nome + "</td>"
      result += "<td> <input type='checkbox' id='cheque_#{cheque.id}' onclick='selecionou_cheque(#{cheque.id});'</input></td> " 
      result += "</tr>"
    end
    result += "</table>"
    render :json =>result.to_json
  end
end
