class DebitosController < ApplicationController
  layout "adm"
  # GET /debitos
  # GET /debitos.xml
  def index
    @debitos = Debito.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @debitos }
    end
  end

  # GET /debitos/1
  # GET /debitos/1.xml
  def show
    @debito = Debito.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @debito }
    end
  end

  # GET /debitos/new
  # GET /debitos/new.xml
  def new
    @debito = Debito.new
    @debito.paciente_id = params[:paciente_id]
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @debito }
    end
  end

  # GET /debitos/1/edit
  def edit
    @debito = Debito.find(params[:id])
  end

  # POST /debitos
  # POST /debitos.xml
  def create
    @debito = Debito.new(params[:debito])
    @debito.data = params[:datepicker].to_date
    respond_to do |format|
      if @debito.save
        format.html { redirect_to(abre_paciente_path(:id=>@debito.paciente_id)) }
        format.xml  { render :xml => @debito, :status => :created, :location => @debito }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @debito.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /debitos/1
  # PUT /debitos/1.xml
  def update
    @debito = Debito.find(params[:id])

    respond_to do |format|
      if @debito.update_attributes(params[:debito])
        format.html { redirect_to(abre_paciente_path(:id=>@debito.paciente_id)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @debito.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /debitos/1
  # DELETE /debitos/1.xml
  def destroy
    @debito = Debito.find(params[:id])
    @debito.destroy

    respond_to do |format|
      format.html { redirect_to(abre_paciente_path(:id=>@debito.paciente_id)) }
      format.xml  { head :ok }
    end
  end
  
  def pacientes_em_debito
    if params[:tipo] == 'ortodontia'
      @pacientes = Paciente.da_clinica(session[:clinica_id]).por_nome.de_ortodontia
    else
      @pacientes = Paciente.da_clinica(session[:clinica_id]).por_nome.de_clinica
    end
    @em_debito = []
    @tabelas = Tabela.ativas.por_nome
    debugger
    @pacientes.each do |pac|
      if params['tabela_' + pac.tabela_id.to_s]
        puts pac.nome + " > " + pac.saldo.real.to_s
        @em_debito << pac if pac.em_debito?
      end
    end
  end
  
  def pacientes_fora_da_lista
    if params[:datepicker]
      @data_inicial = params[:datepicker].to_date
      @data_final = params[:datepicker2].to_date
    else
      @data_inicial = Date.today - 1.month
      @data_final = Date.today
    end
    @pacientes = Paciente.fora_da_lista_de_debito_entre(@data_inicial, @data_final).da_clinica(session[:clinica_id])
  end
end
