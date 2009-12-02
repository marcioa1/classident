class DentistasController < ApplicationController
  layout "adm"
  before_filter :require_user
  # GET /dentistas
  # GET /dentistas.xml
  def index
    if session[:clinica_id].to_i > 0
      @dentistas = Clinica.find(session[:clinica_id]).dentistas
    else
      @dentistas = Dentista.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dentistas }
    end
  end

  # GET /dentistas/1
  # GET /dentistas/1.xml
  def show
    @dentista = Dentista.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dentista }
    end
  end

  # GET /dentistas/new
  # GET /dentistas/new.xml
  def new
    @dentista = Dentista.new
    @clinicas = Clinica.all(:order=>:nome)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dentista }
    end
  end

  # GET /dentistas/1/edit
  def edit
    @dentista = Dentista.find(params[:id])
    @clinicas = Clinica.all(:order=>:nome)
  end

  # POST /dentistas
  # POST /dentistas.xml
  def create
    @dentista = Dentista.new(params[:dentista])
    @dentista.clinicas = []
    clinicas = Clinica.all
    clinicas.each() do |clinica|
      if params["clinica_#{clinica.id.to_s}"]
        @dentista.clinicas << clinica
      end      
    end
    respond_to do |format|
      if @dentista.save
        format.html { redirect_to(@dentista) }
        format.xml  { render :xml => @dentista, :status => :created, :location => @dentista }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dentista.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /dentistas/1
  # PUT /dentistas/1.xml
  def update
    @dentista = Dentista.find(params[:id])
    @dentista.clinicas = []
    clinicas = Clinica.all
    clinicas.each() do |clinica|
      if params["clinica_#{clinica.id.to_s}"]
        @dentista.clinicas << clinica
      end      
    end
    respond_to do |format|
      if @dentista.update_attributes(params[:dentista])
        format.html { redirect_to(dentistas_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dentista.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dentistas/1
  # DELETE /dentistas/1.xml
  def destroy
    @dentista = Dentista.find(params[:id])
    @dentista.ativo = false
    @dentista.save

    respond_to do |format|
      format.html { redirect_to(dentistas_url) }
      format.xml  { head :ok }
    end
  end

  def abre
    @dentista = Dentista.find(params[:id])  
    @clinicas = Clinica.all(:order=>:nome)
    @clinica_1 = "1"
    @inicio = Date.today
    @fim = Date.today
  end
  
  def producao
    dentista = Dentista.find(params[:id])
    @producao = dentista.busca_producao 
    saida = "<table>"
    @producao.each() do |tratamento|
      saida += "<tr><td>"+tratamento.paciente.nome + "</td><td>" + tratamento.valor.real.to_s + "</td></tr>"
    end
    saida += "</table>"
    render :json => saida.to_json
  end
  
end
