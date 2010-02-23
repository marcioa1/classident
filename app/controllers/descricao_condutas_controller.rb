class DescricaoCondutasController < ApplicationController

  layout "adm"
  
  # GET /descricao_condutas
  # GET /descricao_condutas.xml
  def index
    @descricao_condutas = DescricaoConduta.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @descricao_condutas }
    end
  end

  # GET /descricao_condutas/1
  # GET /descricao_condutas/1.xml
  def show
    @descricao_conduta = DescricaoConduta.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @descricao_conduta }
    end
  end

  # GET /descricao_condutas/new
  # GET /descricao_condutas/new.xml
  def new
    @descricao_conduta = DescricaoConduta.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @descricao_conduta }
    end
  end

  # GET /descricao_condutas/1/edit
  def edit
    @descricao_conduta = DescricaoConduta.find(params[:id])
  end

  # POST /descricao_condutas
  # POST /descricao_condutas.xml
  def create
    @descricao_conduta = DescricaoConduta.new(params[:descricao_conduta])

    respond_to do |format|
      if @descricao_conduta.save
        format.html { redirect_to(descricao_condutas_path) }
        format.xml  { render :xml => @descricao_conduta, :status => :created, :location => @descricao_conduta }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @descricao_conduta.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /descricao_condutas/1
  # PUT /descricao_condutas/1.xml
  def update
    @descricao_conduta = DescricaoConduta.find(params[:id])

    respond_to do |format|
      if @descricao_conduta.update_attributes(params[:descricao_conduta])
        format.html { redirect_to(descricao_condutas_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @descricao_conduta.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /descricao_condutas/1
  # DELETE /descricao_condutas/1.xml
  def destroy
    @descricao_conduta = DescricaoConduta.find(params[:id])
    @descricao_conduta.destroy

    respond_to do |format|
      format.html { redirect_to(descricao_condutas_url) }
      format.xml  { head :ok }
    end
  end
end
