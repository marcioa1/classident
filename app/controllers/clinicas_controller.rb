class ClinicasController < ApplicationController
  
  layout "adm"
  
  def selecionou_clinica
    session[:clinica_id] = params[:clinica_id]
    @clinica_atual = Clinica.find(params[:clinica_id])
    if @clinica_atual.e_administracao
      redirect_to administracao_path
    else  
      redirect_to pesquisa_pacientes_path
    end
  end
  
  def producao_entre_datas
    @valores = []
    if params[:datepicker].nil?
      @data_inicial = Date.today
      @data_final = Date.today
    else
      @data_inicial = params[:datepicker].to_date
      @data_final = params[:datepicker2].to_date
    end
    @dentistas = Clinica.find(session[:clinica_id]).dentistas.por_nome
    @dentistas.each do |den|
      mensal = den.producao_entre_datas(@data_inicial,@data_final)
      if mensal.split("/")[1].to_f > 0.0
        @valores << (mensal + "/" + den.nome)
      end
    end
  end
  
  def producao_anual
    if params[:date]
      @date = Date.new(params[:date][:year].to_i,1,1)
    else
      @date = Date.today
    end
    @valores = []
    @dentistas = Clinica.find(session[:clinica_id]).dentistas.por_nome
    @dentistas.each do |den|
      dentista = []
      dentista[0] = den.nome
      entra = false
      (1..12).each do |mes|
        mensal = den.producao_mensal(@date.year,mes)
        entra = true if mensal> 0.0
        dentista[mes] = mensal
      end
      @valores << dentista if entra
    end
  end
  
  def relatorio_alta
    if params[:datepicker].nil?
      @data_inicial = Date.today
      @data_final = Date.today
    else
      @data_inicial = params[:datepicker].to_date
      @data_final = params[:datepicker2].to_date
    end
    debugger
    if params[:somente_em_alta]
      @altas = Alta.da_clinica(session[:clinica_id]).entre_datas(@data_inicial, @data_final).em_alta
    else
      @altas = Alta.da_clinica(session[:clinica_id]).entre_datas(@data_inicial, @data_final)
    end
  end
  
end
