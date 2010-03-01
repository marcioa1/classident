class BancosController < ApplicationController
 
  layout "adm"
  
  before_filter :require_user
  # GET /bancos
  # GET /bancos.xml
  def index
    @bancos = Banco.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bancos }
    end
  end

  # GET /bancos/1
  # GET /bancos/1.xml
  def show
    @banco = Banco.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @banco }
    end
  end

  # GET /bancos/new
  # GET /bancos/new.xml
  def new
    @banco = Banco.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @banco }
    end
  end

  # GET /bancos/1/edit
  def edit
    @banco = Banco.find(params[:id])
  end

  # POST /bancos
  # POST /bancos.xml
  def create
    @banco = Banco.new(params[:banco])

    respond_to do |format|
      if @banco.save
        flash[:notice] = 'Banco was successfully created.'
        format.html { redirect_to(bancos_path) }
        format.xml  { render :xml => @banco, :status => :created, :location => @banco }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @banco.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bancos/1
  # PUT /bancos/1.xml
  def update
    @banco = Banco.find(params[:id])

    respond_to do |format|
      if @banco.update_attributes(params[:banco])
        flash[:notice] = 'Banco was successfully updated.'
        format.html { redirect_to(bancos_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @banco.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bancos/1
  # DELETE /bancos/1.xml
  def destroy
    @banco = Banco.find(params[:id])
    @banco.destroy

    respond_to do |format|
      format.html { redirect_to(bancos_url) }
      format.xml  { head :ok }
    end
  end
end
