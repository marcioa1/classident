class FormasRecebimentosController < ApplicationController
  layout "adm"
  # GET /formas_recebimentos
  # GET /formas_recebimentos.xml
  def index
    @formas_recebimentos = FormasRecebimento.all(:order=>:nome)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @formas_recebimentos }
    end
  end

  # GET /formas_recebimentos/1
  # GET /formas_recebimentos/1.xml
  def show
    @formas_recebimento = FormasRecebimento.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @formas_recebimento }
    end
  end

  # GET /formas_recebimentos/new
  # GET /formas_recebimentos/new.xml
  def new
    @formas_recebimento = FormasRecebimento.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @formas_recebimento }
    end
  end

  # GET /formas_recebimentos/1/edit
  def edit
    @formas_recebimento = FormasRecebimento.find(params[:id])
  end

  # POST /formas_recebimentos
  # POST /formas_recebimentos.xml
  def create
    @formas_recebimento = FormasRecebimento.new(params[:formas_recebimento])

    respond_to do |format|
      if @formas_recebimento.save
        format.html { redirect_to(formas_recebimentos_path) }
        format.xml  { render :xml => @formas_recebimento, :status => :created, :location => @formas_recebimento }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @formas_recebimento.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /formas_recebimentos/1
  # PUT /formas_recebimentos/1.xml
  def update
    @formas_recebimento = FormasRecebimento.find(params[:id])

    respond_to do |format|
      if @formas_recebimento.update_attributes(params[:formas_recebimento])
        flash[:notice] = 'FormasRecebimento was successfully updated.'
        format.html { redirect_to(formas_recebimentos_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @formas_recebimento.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /formas_recebimentos/1
  # DELETE /formas_recebimentos/1.xml
  def destroy
    @formas_recebimento = FormasRecebimento.find(params[:id])
    @formas_recebimento.destroy

    respond_to do |format|
      format.html { redirect_to(formas_recebimentos_url) }
      format.xml  { head :ok }
    end
  end
end
