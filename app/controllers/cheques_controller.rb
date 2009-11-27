class ChequesController < ApplicationController

  layout "adm"
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
      data_inicial = params[:datepicker].to_date
      data_final = params[:datepicker2].to_date
    else
      data_inicial = Date.today - Date.today.day.days + 1.day
      data_final = Date.today
    end
    
    @cheques = []
    if params[:opcao] == "todos"
      @cheques = Cheque.por_bom_para.da_clinica(session[:clinica_id]).entre_datas(data_inicial,data_final)
    end
    if params[:opcao] == "disponiveis"
      @cheques = Cheque.por_bom_para.da_clinica(session[:clinica_id]).entre_datas(data_inicial,data_final).disponiveis
    end
    if params[:opcao]== "devolvido_2_vezes"
      @cheques = Cheque.por_bom_para.da_clinica(session[:clinica_id]).entre_datas(data_inicial,data_final).devolvido_duas_vezes
    end 
    if params[:opcao]=="administracao"     
      @cheques = Cheque.por_bom_para.da_clinica(session[:clinica_id]).entre_datas(data_inicial,data_final).entregue_a_administracao
    end
      
     #TODO fazer parametros de situação de cheque
  end
  
  def recebe_cheques
    debugger
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
    @cheques = Cheque.entregue_a_administracao
  end
  
  def registra_recebimento_de_cheques
    #TODO fazer a cofnirmacao do recebimento do cheque na adm
  end
end
