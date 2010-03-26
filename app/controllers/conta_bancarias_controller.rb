class ContaBancariasController < ApplicationController
 
  layout "adm"
  # GET /conta_bancarias
  # GET /conta_bancarias.xml
  def index
    @conta_bancarias = ContaBancaria.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @conta_bancarias }
    end
  end

  # GET /conta_bancarias/1
  # GET /conta_bancarias/1.xml
  def show
    @conta_bancaria = ContaBancaria.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @conta_bancaria }
    end
  end

  # GET /conta_bancarias/new
  # GET /conta_bancarias/new.xml
  def new
    @conta_bancaria = ContaBancaria.new
    @clinicas = Clinica.por_nome.collect{|cl| [cl.nome, cl.id]}
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @conta_bancaria }
    end
  end

  # GET /conta_bancarias/1/edit
  def edit
    @conta_bancaria = ContaBancaria.find(params[:id])
    @clinicas = Clinica.por_nome.collect{|cl| [cl.nome, cl.id]}
  end

  # POST /conta_bancarias
  # POST /conta_bancarias.xml
  def create
    @conta_bancaria = ContaBancaria.new(params[:conta_bancaria])

    respond_to do |format|
      if @conta_bancaria.save
        flash[:notice] = 'ContaBancaria was successfully created.'
        format.html { redirect_to(conta_bancarias_path) }
        format.xml  { render :xml => @conta_bancaria, :status => :created, :location => @conta_bancaria }
      else
        @clinicas = Clinica.por_nome.collect{|cl| [cl.nome, cl.id]}
        format.html { render :action => "new" }
        format.xml  { render :xml => @conta_bancaria.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /conta_bancarias/1
  # PUT /conta_bancarias/1.xml
  def update
    @conta_bancaria = ContaBancaria.find(params[:id])

    respond_to do |format|
      if @conta_bancaria.update_attributes(params[:conta_bancaria])
        flash[:notice] = 'ContaBancaria was successfully updated.'
        format.html { redirect_to(@conta_bancaria) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @conta_bancaria.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /conta_bancarias/1
  # DELETE /conta_bancarias/1.xml
  def destroy
    @conta_bancaria = ContaBancaria.find(params[:id])
    @conta_bancaria.destroy

    respond_to do |format|
      format.html { redirect_to(conta_bancarias_url) }
      format.xml  { head :ok }
    end
  end
end
