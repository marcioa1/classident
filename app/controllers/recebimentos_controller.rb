class RecebimentosController < ApplicationController
  layout "adm"
  # GET /recebimentos
  # GET /recebimentos.xml
  def index
    @recebimentos = Recebimento.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @recebimentos }
    end
  end

  # GET /recebimentos/1
  # GET /recebimentos/1.xml
  def show
    @recebimento = Recebimento.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @recebimento }
    end
  end

  # GET /recebimentos/new
  # GET /recebimentos/new.xml
  def new
    @bancos = Banco.all(:order=>:nome).collect{|obj| [obj.numero + " - " + obj.nome,obj.id]}
    @formas_recebimentos = FormasRecebimento.all.collect{|obj| [obj.nome,obj.id]}
    @recebimento = Recebimento.new
    @recebimento.cheque = Cheque.new
    @paciente = Paciente.find(params[:paciente_id])
    @recebimento.paciente_id = @paciente.id
    @recebimento.clinica_id = @paciente.clinica_id
    @recebimento.cheque.clinica_id = @paciente.clinica_id
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @recebimento }
    end
  end

  # GET /recebimentos/1/edit
  def edit
    @recebimento = Recebimento.find(params[:id])
  end

  # POST /recebimentos
  # POST /recebimentos.xml
  def create
    @recebimento = Recebimento.new(params[:recebimento])
    debugger
    @recebimento.data = params[:datepicker].to_date
    if FormasRecebimento.find(params[:formas_recebimento_id]).nome.downcase == "cheque"
      @recebimento.cheque.bom_para = params[:datepicker2].to_date
      @recebimento.cheque.clinica_id = session[:clinica_id]
      @recebimento.cheque.paciente_id = @recebimento.paciente_id
    else
      @recebimento.cheque = nil
    end
    respond_to do |format|
      if @recebimento.save 
        format.html { redirect_to(abre_paciente_path(:id=>@recebimento.paciente_id)) }
        format.xml  { render :xml => @recebimento, :status => :created, :location => @recebimento }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @recebimento.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /recebimentos/1
  # PUT /recebimentos/1.xml
  def update
    @recebimento = Recebimento.find(params[:id])

    respond_to do |format|
      if @recebimento.update_attributes(params[:recebimento])
        flash[:notice] = 'Recebimento was successfully updated.'
        format.html { redirect_to(@recebimento) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @recebimento.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /recebimentos/1
  # DELETE /recebimentos/1.xml
  def destroy
    @recebimento = Recebimento.find(params[:id])
    @recebimento.destroy

    respond_to do |format|
      format.html { redirect_to(recebimentos_url) }
      format.xml  { head :ok }
    end
  end
  
  def relatorio
    @tipos_recebimento = FormasRecebimento.por_nome.collect{|obj| [obj.nome, obj.id]}
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
     @recebimentos = Recebimento.por_data.entre_datas(@data_inicial, @data_final)
  end
  
  def cheques_recebidos
    @cheques = Cheque.por_bom_para.da_clinica(session[:clinica_id])
  end
  
end
