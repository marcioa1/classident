class TrabalhoProteticosController < ApplicationController
  layout "adm"
  # GET /trabalho_proteticos
  # GET /trabalho_proteticos.xml
  def index
    @trabalho_proteticos = TrabalhoProtetico.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @trabalho_proteticos }
    end
  end

  # GET /trabalho_proteticos/1
  # GET /trabalho_proteticos/1.xml
  def show
    @trabalho_protetico = TrabalhoProtetico.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @trabalho_protetico }
    end
  end

  # GET /trabalho_proteticos/new
  # GET /trabalho_proteticos/new.xml
  def new
    @paciente = Paciente.find(params[:paciente_id])
    @trabalho_protetico = TrabalhoProtetico.new
    @trabalho_protetico.paciente = @paciente
    @trabalho_protetico.clinica_id = session[:clinica_id]
    @dentistas = @clinica_atual.dentistas.collect{|obj| [obj.nome,obj.id]}.sort
    @proteticos = @clinica_atual.proteticos.collect{|obj| [obj.nome,obj.id]}.sort

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @trabalho_protetico }
    end
  end

  # GET /trabalho_proteticos/1/edit
  def edit
    @trabalho_protetico = TrabalhoProtetico.find(params[:id])
    @paciente = @trabalho_protetico.paciente
    @dentistas = @clinica_atual.dentistas.collect{|obj| [obj.nome,obj.id]}.sort
    @proteticos = Protetico.por_nome.collect{|obj| [obj.nome,obj.id]}
  end

  # POST /trabalho_proteticos
  # POST /trabalho_proteticos.xml
  def create
    @trabalho_protetico = TrabalhoProtetico.new(params[:trabalho_protetico])
    @trabalho_protetico.data_de_envio = params[:datepicker].to_date if params[:datepicker]
    @trabalho_protetico.data_prevista_de_devolucao = params[:datepicker2].to_date if params[:datepicker2]
    @trabalho_protetico.data_de_devolucao = params[:datepicker3].to_date if !params[:datepicker3].blank?
    respond_to do |format|
      if @trabalho_protetico.save
        format.html { redirect_to( abre_paciente_path(@trabalho_protetico.paciente)) }
        format.xml  { render :xml => @trabalho_protetico, :status => :created, :location => @trabalho_protetico }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @trabalho_protetico.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /trabalho_proteticos/1
  # PUT /trabalho_proteticos/1.xml
  def update
    @trabalho_protetico = TrabalhoProtetico.find(params[:id])

    respond_to do |format|
      if @trabalho_protetico.update_attributes(params[:trabalho_protetico])
        flash[:notice] = 'TrabalhoProtetico was successfully updated.'
        format.html { redirect_to(abre_paciente_path(@trabalho_protetico.paciente)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @trabalho_protetico.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /trabalho_proteticos/1
  # DELETE /trabalho_proteticos/1.xml
  def destroy
    @trabalho_protetico = TrabalhoProtetico.find(params[:id])
    @trabalho_protetico.destroy

    respond_to do |format|
      format.html { redirect_to(trabalho_proteticos_url) }
      format.xml  { head :ok }
    end
  end
  
  def registra_devolucao_de_trabalho
    @trabalho = TrabalhoProtetico.find(params[:id])
    @trabalho.data_de_devolucao = Time.now
    @trabalho.save
    render :nothing=>true
  end
  
end
