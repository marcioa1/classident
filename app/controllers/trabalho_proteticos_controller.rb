class TrabalhoProteticosController < ApplicationController
  layout "adm"
  before_filter :require_user

  before_filter :busca_trabalho, :only =>[:show, :edit, :update, :destroy]

  def index
    @trabalho_proteticos = TrabalhoProtetico.all
  end

  def show
  end

  def new
    @paciente                          = Paciente.find(params[:paciente_id])
    @trabalho_protetico                = TrabalhoProtetico.new
    if params[:tratamento_id]
      @trabalho_protetico.tratamento_id  = params[:tratamento_id] 
      @tratamento                        = Tratamento.find(params[:tratamento_id])
      @trabalho_protetico.dentista       = @tratamento.dentista
      @trabalho_protetico.dente          = @tratamento.dente
    end
    @trabalho_protetico.paciente       = @paciente
    @trabalho_protetico.clinica_id     = session[:clinica_id]
    @dentistas                         = @clinica_atual.dentistas.ativos.collect{|obj| [obj.nome,obj.id]}.sort
    @proteticos                        = @clinica_atual.proteticos.ativos.collect{|obj| [obj.nome,obj.id]}.sort
  end

  def edit
    @paciente   = @trabalho_protetico.paciente
    @dentistas  = @clinica_atual.dentistas.ativos.collect{|obj| [obj.nome,obj.id]}.sort
    @proteticos = Protetico.por_nome.ativos.collect{|obj| [obj.nome,obj.id]}
  end

  def create
    @trabalho_protetico                            = TrabalhoProtetico.new(params[:trabalho_protetico])
    @trabalho_protetico.data_de_envio              = params[:datepicker].to_date if params[:datepicker]
    @trabalho_protetico.data_prevista_de_devolucao = params[:datepicker2].to_date if params[:datepicker2]
    @trabalho_protetico.data_de_devolucao          = params[:datepicker3].to_date if !params[:datepicker3].blank?
    if @trabalho_protetico.save
      redirect_to( abre_paciente_path(:id => @trabalho_protetico.paciente_id)) 
    else
      render :action => "new" 
    end
  end

  def update
    @trabalho_protetico = TrabalhoProtetico.find(params[:id])

    if @trabalho_protetico.update_attributes(params[:trabalho_protetico])
      flash[:notice] = 'TrabalhoProtetico alterado com sucesso.'
      redirect_to(abre_paciente_path(@trabalho_protetico.paciente)) 
    else
      render :action => "edit" 
    end
  end

  def destroy
    @trabalho_protetico.destroy
    #TODO refazer este redirect
    debugger
    if session[:origem]
      redirect_to session[:origem]
    else
      redirect_to(trabalho_proteticos_url) 
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
