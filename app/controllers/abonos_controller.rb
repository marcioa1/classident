class AbonosController < ApplicationController

  layout "adm"
  
  before_filter :require_master_user
  
  # GET /abonos
  # GET /abonos.xml
  def index
    if params[:datepicker]
      @data_inicial = params[:datepicker].to_date
    else
      @data_inicial = primeiro_dia_do_mes
    end
    if params[:datepicker2]
      @data_final = params[:datepicker2].to_date
    else
      @data_final = Date.today
    end
    @abonos = Abono.da_classident.entre_datas(@data_inicial, @data_final)
    @abonos = [] if @abonos.nil?
# debugger
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
    @abono          = Abono.new
    @paciente       = Paciente.find(params[:paciente_id])
    @abono.paciente = @paciente
    @abono.valor    = @paciente.mensalidade_de_ortodontia
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @abono }
    end
  end

  # GET /abonos/1/edit
  def edit
    @abono    = Abono.find(params[:id])
    @paciente = @abono.paciente
  end

  # POST /abonos
  # POST /abonos.xml
  def create
    @abono            = Abono.new(params[:abono])
    @abono.clinica_id = session[:clinica_id]
    respond_to do |format|
      if @abono.save
        flash[:notice] = 'Abono alterado com sucesso.'
        format.html { redirect_to(:back) }
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
        flash[:notice] = 'Abono alterado com sucesso.'
        format.html { redirect_to(abonos_path) }
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
