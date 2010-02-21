class IndicacaosController < ApplicationController

  layout "adm"

  # GET /indicacaos
  # GET /indicacaos.xml
  def index
    @indicacaos = Indicacao.por_descricao

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @indicacaos }
    end
  end

  # GET /indicacaos/1
  # GET /indicacaos/1.xml
  def show
    @indicacao = Indicacao.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @indicacao }
    end
  end

  # GET /indicacaos/new
  # GET /indicacaos/new.xml
  def new
    @indicacao = Indicacao.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @indicacao }
    end
  end

  # GET /indicacaos/1/edit
  def edit
    @indicacao = Indicacao.find(params[:id])
  end

  # POST /indicacaos
  # POST /indicacaos.xml
  def create
    @indicacao = Indicacao.new(params[:indicacao])

    respond_to do |format|
      if @indicacao.save
        format.html { redirect_to(indicacaos_path) }
        format.xml  { render :xml => @indicacao, :status => :created, :location => @indicacao }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @indicacao.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /indicacaos/1
  # PUT /indicacaos/1.xml
  def update
    @indicacao = Indicacao.find(params[:id])

    respond_to do |format|
      if @indicacao.update_attributes(params[:indicacao])
        format.html { redirect_to(indicacaos_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @indicacao.errors, :status => :unprocessable_entity }
      end
    end
  end

 
end
