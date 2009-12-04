class RecebimentosController < ApplicationController
  layout "adm"
  before_filter :require_user
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
    @bancos = Banco.all(:order=>:nome).collect{|obj| [obj.numero + " - " + obj.nome,obj.id]}
    @formas_recebimentos = FormasRecebimento.all.collect{|obj| [obj.nome,obj.id]}
    
  end

  # POST /recebimentos
  # POST /recebimentos.xml
  def create
    @recebimento = Recebimento.new(params[:recebimento])
    @recebimento.data = params[:datepicker].to_date
    if @recebimento.em_cheque?
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
    @recebimento.data = params[:datepicker].to_date
    if @recebimento.em_cheque?
      @recebimento.cheque.bom_para = params[:datepicker2].to_date
      @recebimento.cheque.clinica_id = session[:clinica_id]
      @recebimento.cheque.paciente_id = @recebimento.paciente_id
    else
      @recebimento.cheque = nil
    end

    respond_to do |format|
      if @recebimento.update_attributes(params[:recebimento])
        format.html { redirect_to(abre_paciente_path(:id=>@recebimento.paciente_id)) }
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
     if params[:datepicker]
       @data_inicial = params[:datepicker].to_date
       @data_final = params[:datepicker2].to_date
     else
       @data_inicial = Date.today  - Date.today.day.days + 1.day
       @data_final = Date.today
     end
     @recebimentos = Recebimento.da_clinica(session[:clinica_id]).
               por_data.entre_datas(@data_inicial, @data_final).
               formas(params[:tipo_recebimento_id])
  end
  
  def das_clinicas
    if params[:datepicker]
      inicio = params[:datepicker].to_date
      fim = params[:datepicker2].to_date
    else
      inicio = Date.today
      fim = Date.today
      params[:datepicker] = inicio.to_s_br
      params[:datepicker2] = fim.to_s_br
    end
    @todas_as_clinicas = Clinica.por_nome
    selecionadas = ""
    @todas_as_clinicas.each() do |clinica|
      if params["clinica_#{clinica.id.to_s}"]
       selecionadas += clinica.id.to_s + ","
      end      
    end
    @recebimentos = Recebimento.por_data.
       das_clinicas(selecionadas.split(",").to_a).
       entre_datas(inicio,fim)

  end
  
end
