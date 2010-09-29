class EntradasController < ApplicationController
  layout "adm"
  before_filter :require_user
  before_filter :quinzena, :only=>:administracao

  def index
    if params[:data]
      @data = params[:data].to_date
    else
      @data = Date.today
    end  
    @entradas = Entrada.entrada.do_mes(@data).da_clinica(session[:clinica_id])
    @remessas = Entrada.remessa.do_mes(@data).da_clinica(session[:clinica_id])
  end

  def show
    @entrada = Entrada.find(params[:id])
  end

  def new
    @entrada = Entrada.new
    @entrada.data = Date.today
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
    if tipo=="Remessa"
      @entrada.valor = @entrada.valor * -1
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
  
  def administracao
    @entradas = Entrada.remessa.entre_datas(@data_inicial, @data_final)
  end
  
  def registra_confirmacao_de_entrada
    entrada_ids = params[:data].split(',')
    entrada_ids.each do |id|
      Entrada.update(id, :data_confirmacao_da_entrada => Time.now)
    end
    head :ok
  end
  
end
