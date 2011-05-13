class AbonosController < ApplicationController

  layout "adm"
  
  before_filter :require_master_user
  
  # GET /abonos
  # GET /abonos.xml
  def index
    @abonos = Abono.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @abonos }
    end
  end

  # GET /abonos/1
  # GET /abonos/1.xml
  def show
    @abono = Abono.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @abono }
    end
  end

  # GET /abonos/new
  # GET /abonos/new.xml
  def new
    @abono = Abono.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @abono }
    end
  end

  # GET /abonos/1/edit
  def edit
    @abono = Abono.find(params[:id])
  end

  # POST /abonos
  # POST /abonos.xml
  def create
    @abono = Abono.new(params[:abono])

    respond_to do |format|
      if @abono.save
        flash[:notice] = 'Abono was successfully created.'
        format.html { redirect_to(@abono) }
        format.xml  { render :xml => @abono, :status => :created, :location => @abono }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @abono.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /abonos/1
  # PUT /abonos/1.xml
  def update
    @abono = Abono.find(params[:id])

    respond_to do |format|
      if @abono.update_attributes(params[:abono])
        flash[:notice] = 'Abono was successfully updated.'
        format.html { redirect_to(@abono) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @abono.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /abonos/1
  # DELETE /abonos/1.xml
  def destroy
    @abono = Abono.find(params[:id])
    @abono.destroy

    respond_to do |format|
      format.html { redirect_to(abonos_url) }
      format.xml  { head :ok }
    end
  end
  
    def pesquisa_nomes
     nomes = Paciente.all(:select=>'id,nome', :conditions=>["nome like ? and clinica_id = ? ", "#{params[:term].nome_proprio}%", session[:clinica_id] ])  
     result = []
     nomes.each do |nome|
       result << nome.nome
     end
     render :json => result.to_json
   end

end
