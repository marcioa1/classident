class TrabalhoProteticosController < ApplicationController
  layout "adm"

  before_filter :busca_trabalho, :only =>[:show, :edit, :update, :destroy]

  def index
    @trabalho_proteticos = TrabalhoProtetico.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @trabalho_proteticos }
    end
  end

  def show

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @trabalho_protetico }
    end
  end

  def new
    @paciente                      = Paciente.find(params[:paciente_id])
    @trabalho_protetico            = TrabalhoProtetico.new
    @trabalho_protetico.paciente   = @paciente
    @trabalho_protetico.clinica_id = session[:clinica_id]
    @dentistas                     = @clinica_atual.dentistas.collect{|obj| [obj.nome,obj.id]}.sort
    @proteticos                    = @clinica_atual.proteticos.collect{|obj| [obj.nome,obj.id]}.sort

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @trabalho_protetico }
    end
  end

  def edit
    @paciente   = @trabalho_protetico.paciente
    @dentistas  = @clinica_atual.dentistas.collect{|obj| [obj.nome,obj.id]}.sort
    @proteticos = Protetico.por_nome.collect{|obj| [obj.nome,obj.id]}
  end

  def create
    @trabalho_protetico                            = TrabalhoProtetico.new(params[:trabalho_protetico])
    @trabalho_protetico.data_de_envio              = params[:datepicker].to_date if params[:datepicker]
    @trabalho_protetico.data_prevista_de_devolucao = params[:datepicker2].to_date if params[:datepicker2]
    @trabalho_protetico.data_de_devolucao          = params[:datepicker3].to_date if !params[:datepicker3].blank?
    respond_to do |format|
      if @trabalho_protetico.save
        format.html { redirect_to( abre_paciente_path(:id => @trabalho_protetico.paciente_id)) }
        format.xml  { render :xml => @trabalho_protetico, :status => :created, :location => @trabalho_protetico }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @trabalho_protetico.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @trabalho_protetico = TrabalhoProtetico.find(params[:id])

    respond_to do |format|
      if @trabalho_protetico.update_attributes(params[:trabalho_protetico])
        flash[:notice] = 'TrabalhoProtetico alterado com sucesso.'
        format.html { redirect_to(abre_paciente_path(@trabalho_protetico.paciente)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @trabalho_protetico.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
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

  def busca_trabalho
    @trabalho_protetico = TrabalhoProtetico.find(params[:id])
  end
  
end
