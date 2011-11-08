class TrabalhoProteticosController < ApplicationController
  layout "adm"
  before_filter :require_user

  before_filter :busca_trabalho, :only =>[:show, :edit, :update, :destroy]

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
    params[:trabalho_protetico][:valor] = params[:trabalho_protetico][:valor].gsub(".","").gsub(",",".").to_f rescue "0.0"

    @trabalho_protetico                            = TrabalhoProtetico.new(params[:trabalho_protetico])
    # @trabalho_protetico.data_de_envio              = params[:datepicker].to_date if params[:datepicker]
    # @trabalho_protetico.data_prevista_de_devolucao = params[:datepicker2].to_date if params[:datepicker2]
    # @trabalho_protetico.data_de_devolucao          = params[:datepicker3].to_date if !params[:datepicker3].blank?
    if @trabalho_protetico.save
      @trabalho_protetico.tratamento.adiciona_custo(@trabalho_protetico.valor) if @trabalho_protetico.tratamento.present? 
      redirect_to( abre_paciente_path(:id => @trabalho_protetico.paciente_id)) 
    else
      render :action => "new" 
    end
  end

  def update
    custo_anterior      = @trabalho_protetico.valor
    params[:trabalho_protetico][:valor] = params[:trabalho_protetico][:valor].gsub(".","").gsub(",",".").to_f rescue "0.0"

    if @trabalho_protetico.update_attributes(params[:trabalho_protetico])
      flash[:notice] = 'TrabalhoProtetico alterado com sucesso.'
      if @trabalho_protetico.tratamento.present? && custo_anterior != @trabalho_protetico.valor
        @trabalho_protetico.tratamento.adiciona_custo(@trabalho_protetico.valor - custo_anterior)
      end
      redirect_to(abre_paciente_path(@trabalho_protetico.paciente)) 
    else
      render :action => "edit" 
    end
  end

  def destroy
    @trabalho_protetico.tratamento.adiciona_custo(@trabalho_protetico.valor * (-1)) if @trabalho_protetico.tratamento.present? 
    @trabalho_protetico.destroy
    #TODO refazer este redirect
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
  
  def libera_pagamento
    ids_array = params[:ids].split(',')
    ids_array.each do |id|
      trab = TrabalhoProtetico.find(id)
      trab.update_attribute('data_liberacao_para_pagamento' , Time.current)
    end
    head :ok
  end

  def cancelar_liberacao
    trabalho_protetico = TrabalhoProtetico.find(params[:id])
    trabalho_protetico.update_attribute('data_liberacao_para_pagamento', nil)
    head :ok
  end
  
end
