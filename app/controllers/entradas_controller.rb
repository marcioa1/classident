class EntradasController < ApplicationController
  layout "adm"
  before_filter :require_user
  # GET /entradas
  # GET /entradas.xml
  def index
    if params[:data]
      @data = params[:data].to_date
    else
      @data = Date.today
    end  
    @entradas = Entrada.entrada.do_mes(@data).da_clinica(session[:clinica_id])
    @remessas = Entrada.remessa.do_mes(@data).da_clinica(session[:clinica_id])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @entradas }
    end
  end

  # GET /entradas/1
  # GET /entradas/1.xml
  def show
    @entrada = Entrada.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @entrada }
    end
  end

  # GET /entradas/new
  # GET /entradas/new.xml
  def new
    @entrada = Entrada.new
    @entrada.data = Date.today
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @entrada }
    end
  end

  # GET /entradas/1/edit
  def edit
    @entrada = Entrada.find(params[:id])
  end

  # POST /entradas
  # POST /entradas.xml
  def create
    tipo = params[:tipo]
    @entrada = Entrada.new(params[:entrada])
    @entrada.data = params[:datepicker].to_date
    @entrada.clinica_id = session[:clinica_id]
    if tipo=="Remessa"
      @entrada.valor = @entrada.valor * -1
    end
    respond_to do |format|
      if @entrada.save
        flash[:notice] = 'Entrada alterada com sucesso.'
        format.html { redirect_to(entradas_path) }
        format.xml  { render :xml => @entrada, :status => :created, :location => @entrada }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @entrada.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /entradas/1
  # PUT /entradas/1.xml
  def update
    @entrada = Entrada.find(params[:id])

    respond_to do |format|
      if @entrada.update_attributes(params[:entrada])
        flash[:notice] = 'Entrada alterada com sucesso.'
        format.html { redirect_to(entradas_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @entrada.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /entradas/1
  # DELETE /entradas/1.xml
  def destroy
    @entrada = Entrada.find(params[:id])
    @entrada.destroy

    respond_to do |format|
      format.html { redirect_to(entradas_url) }
      format.xml  { head :ok }
    end
  end
end
