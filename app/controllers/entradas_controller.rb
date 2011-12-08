class EntradasController < ApplicationController
  layout "adm"
  before_filter :require_user
  before_filter :quinzena, :only=>:na_administracao

  def index
    if params[:data]
      @data = params[:data].to_date
    else
      @data = Date.today
    end  
    if @clinica_atual.administracao?
      @entradas = Entrada.entrada_na_administracao.do_mes(@data)
      @remessas = Entrada.remessa_da_administracao.do_mes(@data)
    else
      @entradas = Entrada.do_mes(@data).para_clinica(session[:clinica_id])
      @remessas = Entrada.entrada_na_administracao.do_mes(@data).da_clinica(session[:clinica_id])
    end
  end

  def show
    @entrada = Entrada.find(params[:id])
  end

  def new
    @entrada      = Entrada.new
    @entrada.data = Date.today
    @clinicas     = (Clinica.da_classident).collect{|c| [c.nome, c.id] }
  end

  def edit
    @entrada = Entrada.find(params[:id])
  end

  def create
    tipo     = params[:tipo]
    # params[:entrada][:valor] = params[:entrada][:valor].gsub('.', '').gsub(',', '.')
    @entrada = Entrada.new(params[:entrada])
    @entrada.data       = params[:datepicker].to_date
    @entrada.clinica_id = session[:clinica_id]
    if @clinica_atual.administracao?
      @entrada.clinica_destino = Clinica.find(params[:clinica_id])
    else
      @entrada.clinica_destino = Clinica.administracao.first
    end

    if @entrada.save
      flash[:notice] = 'Entrada alterada com sucesso.'
      redirect_to(entradas_path) 
    else
      render :action => "new" 
    end
  end

  def update
    @entrada = Entrada.find(params[:id])

    if @entrada.update_attributes(params[:entrada])
      flash[:notice] = 'Entrada alterada com sucesso.'
      redirect_to(entradas_path) 
    else
      render :action => "edit"
    end
  end

  def destroy
    @entrada = Entrada.find(params[:id])
    @entrada.destroy

    redirect_to(entradas_url) 
  end
  
  def na_administracao
    @entradas = Entrada.entrada_na_administracao.entre_datas(@data_inicial, @data_final)
  end
  
  def registra_confirmacao_de_entrada
    entrada_ids = params[:data].split(',')
    entrada_ids.each do |id|
      Entrada.update(id, :data_confirmacao_da_entrada => Time.now)
    end
    render :json => Time.now.to_s_br.to_json
  end
  
end
