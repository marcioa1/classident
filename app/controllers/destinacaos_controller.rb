class DestinacaosController < ApplicationController
  # GET /destinacaos
  # GET /destinacaos.xml
  def index
    @destinacaos = Destinacao.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @destinacaos }
    end
  end

  # GET /destinacaos/1
  # GET /destinacaos/1.xml
  def show
    @destinacao = Destinacao.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @destinacao }
    end
  end

  # GET /destinacaos/new
  # GET /destinacaos/new.xml
  def new
    @destinacao = Destinacao.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @destinacao }
    end
  end

  # GET /destinacaos/1/edit
  def edit
    @destinacao = Destinacao.find(params[:id])
  end

  # POST /destinacaos
  # POST /destinacaos.xml
  def create
    @destinacao = Destinacao.new(params[:destinacao])

    respond_to do |format|
      if @destinacao.save
        flash[:notice] = 'Destinacao was successfully created.'
        format.html { redirect_to(@destinacao) }
        format.xml  { render :xml => @destinacao, :status => :created, :location => @destinacao }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @destinacao.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /destinacaos/1
  # PUT /destinacaos/1.xml
  def update
    @destinacao = Destinacao.find(params[:id])

    respond_to do |format|
      if @destinacao.update_attributes(params[:destinacao])
        flash[:notice] = 'Destinacao was successfully updated.'
        format.html { redirect_to(@destinacao) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @destinacao.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /destinacaos/1
  # DELETE /destinacaos/1.xml
  def destroy
    @destinacao = Destinacao.find(params[:id])
    @destinacao.destroy

    respond_to do |format|
      format.html { redirect_to(destinacaos_url) }
      format.xml  { head :ok }
    end
  end
end
