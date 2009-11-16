class DebitosController < ApplicationController
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

    respond_to do |format|
      if @debito.save
        flash[:notice] = 'Debito was successfully created.'
        format.html { redirect_to(@debito) }
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
        flash[:notice] = 'Debito was successfully updated.'
        format.html { redirect_to(@debito) }
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
      format.html { redirect_to(debitos_url) }
      format.xml  { head :ok }
    end
  end
end
