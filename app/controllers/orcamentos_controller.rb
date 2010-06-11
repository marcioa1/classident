class OrcamentosController < ApplicationController
  layout "adm"
  before_filter :require_user
  
  before_filter :quinze_dias, :only=>:aproveitamento
  
  def index
    @orcamentos = Orcamento.all
  end

  def show
    @orcamento = Orcamento.find(params[:id])
  end

  def new
    params[:tratamento_ids] = Tratamento.ids_orcamento(params[:paciente_id]).join(",")
    @paciente = Paciente.find(session[:paciente_id], :select=>'id,nome')
    @orcamento = Orcamento.new(:vencimento_primeira_parcela => Date.today + 30.days, :data => Date.today, :forma_de_pagamento => 'cheque_pre')
    @orcamento.paciente = @paciente
    @orcamento.numero = Orcamento.proximo_numero(session[:paciente_id])
    @orcamento.valor = Tratamento.valor_a_fazer(session[:paciente_id])
    @orcamento.desconto = 0
    @orcamento.valor_com_desconto = @orcamento.valor
    @dentistas = Clinica.find(session[:clinica_id]).dentistas.ativos.por_nome.collect{|obj| [obj.nome,obj.id]}
  end

  def edit
    @orcamento = Orcamento.find(params[:id])
    @paciente = @orcamento.paciente
    @dentistas = Clinica.find(session[:clinica_id]).dentistas.ativos.por_nome.collect{|obj| [obj.nome,obj.id]}
  end

  def create
    params[:orcamento][:valor_da_parcela] = params[:orcamento][:valor_da_parcela].gsub('.','').gsub(',','.')
    @orcamento = Orcamento.new(params[:orcamento])
    @orcamento.data = params[:datepicker].to_date
    @orcamento.vencimento_primeira_parcela = params[:orcamento][:vencimento_primeira_parcela].to_date if Date.valid?(params[:orcamento][:vencimento_primeira_parcela])
    @orcamento.data_de_inicio = params[:orcamento][:data_de_inicio].to_date if Date.valid?(params[:orcamento][:data_de_inicio])
    if @orcamento.save
      Tratamento.associa_ao_orcamento(params[:tratamento_ids], @orcamento.id)
      Debito.cria_debitos_do_orcamento(@orcamento.id) unless @orcamento.data_de_inicio.nil?
      redirect_to(abre_paciente_path(@orcamento.paciente_id)) 
    else
      @paciente  = Paciente.find(session[:paciente_id], :select=>'id,nome')
      @dentistas = Clinica.find(session[:clinica_id]).dentistas.ativos.por_nome.collect{|obj| [obj.nome,obj.id]}
      render :action => "new"
    end
  end

  def update
    @orcamento = Orcamento.find(params[:id])
    @orcamento.data = params[:datepicker].to_date
    @orcamento.vencimento_primeira_parcela = params[:datepicker2].to_date
    @orcamento.data_de_inicio = params[:datepicker3].to_date unless params[:datepicker3].blank?
    
    if @orcamento.update_attributes(params[:orcamento])
      redirect_to(abre_paciente_path(@orcamento.paciente_id)) 
    else
      render :action => "edit" 
    end
  end

  def destroy
    @orcamento = Orcamento.find(params[:id])
    @orcamento.destroy

    redirect_to(orcamentos_url) 
  end
  
  def relatorio
    if params[:datepicker].nil?
      params[:datepicker] = primeiro_dia_do_mes.to_s_br
      params[:datepicker2] = Date.today.to_s_br
    end
    if Date.valid?(params[:datepicker]) and Date.valid?(params[:datepicker2])
      if params[:acima_de_um_valor]
        @orcamentos = Orcamento.da_clinica(session[:clinica_id]).entre_datas(params[:datepicker].to_date, params[:datepicker2].to_date).acima_de(params[:valor])
      else
        @orcamentos = Orcamento.da_clinica(session[:clinica_id]).entre_datas(params[:datepicker].to_date, params[:datepicker2].to_date)
      end
    else
      flash[:error] = 'Data inválida.'
    end
  end

  def aproveitamento
    @orcamentos = Orcamento.por_dentista.entre_datas(@data_inicial, @data_final)
    @aberto_por_clinica = Array.new(10,0)
    @iniciado_por_clinica = Array.new(10,0)
    @total_aberto_por_clinica = Array.new(10,0)
    @total_iniciado_por_clinica = Array.new(10,0)
    @aberto_por_dentista = Array.new(10,0)
    @iniciado_por_dentista = Array.new(10,0)
    @total_aberto_por_dentista = Array.new(10,0)
    @total_iniciado_por_dentista = Array.new(10,0)
    @clinicas = Clinica.todas
    @clinicas.each do |clinica|
      @aberto_por_clinica[clinica.id] = Orcamento.em_aberto.entre_datas(@data_inicial, @data_final).da_clinica(clinica.id).size
      @iniciado_por_clinica[clinica.id] = Orcamento.iniciado.entre_datas(@data_inicial, @data_final).da_clinica(clinica.id).size
      @total_aberto_por_clinica[clinica.id] = Orcamento.em_aberto.entre_datas(@data_inicial, @data_final).da_clinica(clinica.id).sum(:valor_com_desconto)
      @total_iniciado_por_clinica[clinica.id] = Orcamento.iniciado.entre_datas(@data_inicial, @data_final).da_clinica(clinica.id).sum(:valor_com_desconto)
    end
    @dentistas = Dentista.ativos.por_nome
    @dentistas.each do |dentista|
      @aberto_por_dentista[dentista.id] = Orcamento.em_aberto.entre_datas(@data_inicial, @data_final).do_dentista(dentista.id).size
      @iniciado_por_dentista[dentista.id] = Orcamento.iniciado.entre_datas(@data_inicial, @data_final).do_dentista(dentista.id).size
      @total_aberto_por_dentista[dentista.id] = Orcamento.em_aberto.entre_datas(@data_inicial, @data_final).do_dentista(dentista.id).sum(:valor_com_desconto)
      @total_iniciado_por_dentista[dentista.id] = Orcamento.iniciado.entre_datas(@data_inicial, @data_final).do_dentista(dentista.id).sum(:valor_com_desconto)
    end
  end

  def monta_tabela_de_parcelas
    numero_de_parcelas = params[:numero_de_parcelas].to_i
    data               = params[:data_primeira_parcela].to_date if Date.valid?(params[:data_primeira_parcela])
    valor              = (params[:valor_da_parcela].to_f / numero_de_parcelas).real
    result = "<div id='parcelas' style='padding-left: 14em; padding-top: 1em;'><table><tr><th>N. parcela</th><th>Data</th><th>Valor</th></tr>"
    #TODO colocar esta motnagem num helper
    (1..numero_de_parcelas).each do |parcela|
      result += "<tr><td align='center'>#{parcela}</td><td>#{data.to_s_br}</td><td>#{valor}</td></tr>"
      data   += 1.month
    end
    result += "</table></div>"
    render :json => result.to_json  
  end
  
end
