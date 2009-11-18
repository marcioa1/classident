class PacientesController < ApplicationController
  layout "adm"
  #TODO Pensar em um layout para clinica e outro para adm
  # GET /pacientes
  # GET /pacientes.xml
  def index
    @pacientes = Paciente.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pacientes }
    end
  end

  # GET /pacientes/1
  # GET /pacientes/1.xml
  def show
    @paciente = Paciente.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @paciente }
    end
  end

  # GET /pacientes/new
  # GET /pacientes/new.xml
  def new
    if session[:clinica_id].to_i == 0
      redirect_to administracao_path
    else
      @tabelas = Tabela.ativas.collect{|obj| [obj.nome,obj.id]}
      @paciente = Paciente.new

      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @paciente }
      end
    end
  end

  # GET /pacientes/1/edit
  def edit
    @paciente = Paciente.find(params[:id])
  end

  # POST /pacientes
  # POST /pacientes.xml
  def create
    @paciente = Paciente.new(params[:paciente])
    @paciente.clinica_id = session[:clinica_id]
    @paciente.codigo = @paciente.gera_codigo()
    @paciente.inicio_tratamento = params[:datepicker2].to_date
#    @paciente.nascimento = params[:datepicker].to_date
    respond_to do |format|
      if @paciente.save
        format.html { redirect_to(pesquisa_pacientes_path) }
        format.xml  { render :xml => @paciente, :status => :created, :location => @paciente }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @paciente.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pacientes/1
  # PUT /pacientes/1.xml
  def update
    @paciente = Paciente.find(params[:id])
    @paciente.inicio_tratamento = params[:datepicker2].to_date
    @paciente.nascimento = params[:datepicker].to_date
    respond_to do |format|
      if @paciente.update_attributes(params[:paciente])
        format.html { redirect_to(abre_paciente_path(:id=>@paciente.id)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @paciente.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pacientes/1
  # DELETE /pacientes/1.xml
  def destroy
    @paciente = Paciente.find(params[:id])
    @paciente.destroy

    respond_to do |format|
      format.html { redirect_to(pacientes_url) }
      format.xml  { head :ok }
    end
  end
  
  def pesquisa
    session[:paciente_id] = nil
    if !session[:paciente_id].nil?
      @paciente = Paciente.find(session[:paciente_id])
      params[:codigo] = @paciente.id
      params[:nome] = @paciente.nome
    end  
    @pacientes =[]
    debugger
    if !params[:codigo].blank?
      if session[:clinica_id].to_i == 0
        @pacientes = Paciente.all(:conditions=>["codigo=?", params[:codigo]])
      else
        @pacientes = Paciente.all(:conditions=>["clinica_id=? and codigo=?", session[:clinica_id], params[:codigo]])
      end
      if !@pacientes.empty?
        if @pacientes.size==1
          redirect_to abre_paciente_path(:id=>@pacientes.first.id)
        else
        end 
      else
        flash[:notice] =  'Não foi encontrado paciente com o código ' + params[:codigo]
        render :action=> "pesquisa"
      end
    else
      if params[:nome]
        if session[:clinica_id] == 0
          @pacientes = Paciente.all(:conditions=>["nome like ?", params[:nome] + '%'])
        else
          @pacientes = Paciente.all(:conditions=>["clinica_id= ? and nome like ?", session[:clinica_id].to_i, params[:nome] + '%'])
        end
      end 
    end 
  end
  
  def abre
    session[:paciente_id] = params[:id]
    @paciente = Paciente.find(params[:id])
    @tabelas = Tabela.ativas.collect{|obj| [obj.nome,obj.id]}
  end
  
end
