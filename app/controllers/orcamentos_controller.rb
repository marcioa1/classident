class OrcamentosController < ApplicationController
  layout "adm"
  before_filter :require_user
  before_filter :find_current, :only=>[:show, :edit, :imprime, :update, :destroy]
  before_filter :quinzena, :only=>:aproveitamento
  
  def index
    @orcamentos = Orcamento.all
  end

  def show
  end

  def new
    params[:tratamento_ids] = Tratamento.ids_orcamento(params[:paciente_id]).join(",")
    @paciente           = Paciente.find(session[:paciente_id], :select=>'id,nome,sequencial,telefone, codigo,celular,clinica_id')
    @orcamento          = Orcamento.new(:vencimento_primeira_parcela => Date.today + 30.days, :data => Date.today, :forma_de_pagamento => 'cheque_pre')
    @orcamento.paciente = @paciente
    @orcamento.numero   = Orcamento.proximo_numero(session[:paciente_id])
    @orcamento.valor    = Tratamento.valor_a_fazer(session[:paciente_id])
    @orcamento.desconto = 0
    @orcamento.valor_com_desconto  = @orcamento.valor
    @dentistas   = Dentista.busca_dentistas(session[:clinica_id])
    @tratamentos = Tratamento.do_paciente(@paciente.id).nao_excluido.nao_feito.sem_orcamento
    @orcamento.dentista_id = @tratamentos[0].dentista_id if !@tratamentos.empty?
  end

  def edit
    @paciente = @orcamento.paciente
    @dentistas = Clinica.find(session[:clinica_id]).dentistas.ativos.por_nome.collect{|obj| [obj.nome,obj.id]}
  end

  def create
    @orcamento                             = Orcamento.new(params[:orcamento])
    @orcamento.vencimento_primeira_parcela = params[:orcamento][:vencimento_primeira_parcela].to_date if Date.valid?(params[:orcamento][:vencimento_primeira_parcela])
    @orcamento.data_de_inicio              = params[:orcamento][:data_de_inicio].to_date if Date.valid?(params[:orcamento][:data_de_inicio])
    @orcamento.clinica_id                  = session[:clinica_id]
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
    if @orcamento.update_attributes(params[:orcamento])
      redirect_to(abre_paciente_path(@orcamento.paciente_id)) 
    else
      @paciente  = @orcamento.paciente
      @dentistas = Clinica.find(session[:clinica_id]).dentistas.ativos.por_nome.collect{|obj| [obj.nome,obj.id]}

      render :action => "edit" 
    end
  end

  def destroy
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
    @titulo = "Orçamentos elaborados entre #{params[:datepicker].to_date} e #{params[:datepicker2].to_date} da clinica #{@clinica_atual.nome}"
  end

  def aproveitamento
    @data_inicial  = params[:datepicker].to_date if Date.valid?(params[:datepicker])
    @data_final    = params[:datepicker2].to_date if Date.valid?(params[:datepicker2])
    @orcamentos                  = Orcamento.por_dentista.entre_datas(@data_inicial, @data_final)
    @aberto_por_clinica          = Array.new(10,0)
    @iniciado_por_clinica        = Array.new(10,0)
    @total_aberto_por_clinica    = Array.new(10,0)
    @total_iniciado_por_clinica  = Array.new(10,0)
    @aberto_por_dentista         = Array.new(10,0)
    @iniciado_por_dentista       = Array.new(10,0)
    @total_aberto_por_dentista   = Array.new(10,0)
    @total_iniciado_por_dentista = Array.new(10,0)
    @clinicas = Clinica.todas
    @clinicas.each do |clinica|
      em_aberto = Orcamento.em_aberto.entre_datas(@data_inicial, @data_final).da_clinica(clinica.id)
      iniciado  = Orcamento.iniciado.entre_datas(@data_inicial, @data_final).da_clinica(clinica.id)
      @aberto_por_clinica[clinica.id]         = em_aberto.size
      @iniciado_por_clinica[clinica.id]       = iniciado.size
      @total_aberto_por_clinica[clinica.id]   = em_aberto.sum(:valor_com_desconto)
      @total_iniciado_por_clinica[clinica.id] = iniciado.sum(:valor_com_desconto)
    end
    @dentistas = Dentista.ativos.por_nome
    @dentistas.each do |dentista|
      em_aberto = Orcamento.em_aberto.entre_datas(@data_inicial, @data_final).do_dentista(dentista.id)
      iniciado  = Orcamento.iniciado.entre_datas(@data_inicial, @data_final).do_dentista(dentista.id)
      @aberto_por_dentista[dentista.id]         = em_aberto.size
      @iniciado_por_dentista[dentista.id]       = iniciado.size
      @total_aberto_por_dentista[dentista.id]   = em_aberto.sum(:valor_com_desconto)
      @total_iniciado_por_dentista[dentista.id] = iniciado.sum(:valor_com_desconto)
    end
  end

  def monta_tabela_de_parcelas
    numero_de_parcelas = params[:numero_de_parcelas].to_i
    data               = params[:data_primeira_parcela].to_date if Date.valid?(params[:data_primeira_parcela])
    valor              = (params[:valor_da_parcela].to_f / numero_de_parcelas).real
    result = Orcamento.monta_tabela_de_parcelas(numero_de_parcelas,data,valor)
    render :json => result.to_json  
  end
  
  def imprime

  require 'prawn/core'
  require "prawn/layout"

  Prawn::Document.generate("public/relatorios/#{session[:clinica_id]}/orcamento.pdf") do |pdf|
    pdf.repeat :all do
      pdf.image "public/images/logo-print.jpg", :align => :left, :vposition => -20
      pdf.bounding_box [10, 700], :width  => pdf.bounds.width do
        pdf.font "Helvetica"
        pdf.text 'Orçamento', :align => :center, :size => 14, :vposition => -20
      end
    end
    
    pdf.move_down 20
    pdf.text "Paciente : #{@orcamento.paciente.nome}", :size=>14
    pdf.move_down 36
    pdf.text "Elaborado em : #{@orcamento.data.to_s_br}"
    pdf.move_down 4
    pdf.text "Elaborado em : #{@orcamento.dentista.nome}"
    pdf.move_down 4
    pdf.text "Valor total : R$ #{@orcamento.valor.real.to_s}"
    if @orcamento.desconto > 0
      pdf.move_down 4
      pdf.text "Desconto :#{ @orcamento.desconto.to_s} + '%'"
      pdf.move_down 4
      pdf.text "Valor final :#{ @orcamento.valor_com_desconto.real.to_s}"
    end
    pdf.move_down 4
    pdf.text "Número de parcelas : #{@orcamento.numero_de_parcelas}"
    pdf.move_down 4
    pdf.text "Valor da parcela : R$ #{@orcamento.valor_da_parcela.real}"
    pdf.move_down 4
    pdf.text "Forma de pagamento : #{@orcamento.forma_de_pagamento}"

    pdf.move_down 8
    pdf.text "Parcelas"
    corpo = [['nº','data', 'valor']]
    [1..@orcamento.numero_de_parcelas].each_with_index do |parcela,index|
      corpo << [(index+1).to_s, @orcamento.vencimento_primeira_parcela.to_s_br , @orcamento.valor_da_parcela.real.to_s]
    end
    # pdf.table(corpo) do
      # column(0).align = 'right'
      # column(1).align = 'center'
    # end

    # header = %w[Name Occupation]
    # data = ["Bender Bending Rodriguez", "Bender"]
  
    pdf.table( corpo) do
      row(0).style(:font_style => :bold, :background_color => 'cccccc')
      column(2).style(:align=>:right)
    end
    # pdf.table corpo
    
    data = @orcamento.tratamentos.map do |trat|
      [
        trat.dente,
        trat.face,
        trat.descricao,
        trat.valor.real.to_s
      ]
    end
    cabe = [['dente','face', 'descrição', 'valor']]
    pdf.move_down 18
    pdf.text "Procedimentos"
    pdf.table( cabe + data, :header => false) do
      row(0).style(:font_style => :bold, :background_color => 'cccccc')
      column(3).style(:align=>:right)
    end

  end

    # Prawn::Document.generate("public/relatorios/orcamento_#{params[:clinica_id]}.pdf") do |pdf|
    # 
    #   pdf.font "Times-Roman"
    #   imprime_cabecalho(pdf, 'Orçamento')
    #   pdf.text "Orçamento", :size=>22, :align=>:center
    #   pdf.move_down 10
    #   pdf.text "Paciente : #{@orcamento.paciente.nome}", :size=>14
    #   pdf.move_down 8
    #   corpo = [
    #             ['Número :', @orcamento.numero],
    #             ['Data :', @orcamento.data.to_s_br],
    #             ['Dentista :', @orcamento.dentista.nome],
    #             ['Valor :', @orcamento.valor.real.to_s],
    #             ['Desconto :', @orcamento.desconto.to_s + '%'],
    #             ['Valor c/ desc.', @orcamento.valor_com_desconto.real.to_s],
    #             ['Forma pgto :', @orcamento.forma_de_pagamento],
    #             ['Núm. parcelas :', @orcamento.numero_de_parcelas],
    #             ['Vencto primeira parc.:', @orcamento.vencimento_primeira_parcela.to_s_br],
    #             ['Valor parcela :', @orcamento.valor_da_parcela.real.to_s]
    #           ]
    #   pdf.table(corpo) do
    #     column(0).align = 'right'
    #     column(1).align = 'center'
    #     end
    #     # , 
    #     #        :align => {0=>:right, 1=>:left},
    #     #        :cell_border => 0)
    #   pdf.move_down 15
    #   
    #   data = @orcamento.vencimento_primeira_parcela - 1.month
    #   parcelas = (1..@orcamento.numero_de_parcelas).each.map do |par|
    #     data = data + 1.month
    #     [par, data.to_s_br, @orcamento.valor_da_parcela.real]
    #   end
    #   
    #   pdf.table(parcelas,
    #             :row_colors =>['FFFFFF', 'DDDDDD'],
    #             :header_color => 'AAAAAA',
    #             :headers=> ['Parcela', 'Data', 'Valor'],
    #             :align => {0=>:right, 1=>:center, 2=>:right},
    #             :cell_style => { :padding => 12 }, 
    #             :width => 300)
    #   
    #   
      head :ok
    # end
    
  end

  def imprime_cabecalho(pdf, titulo)
    pdf.image "public/images/logo-print.jpg", :align => :left
    pdf.text "#{Time.current.to_s_br}", :align => :right, :size=>8
    pdf.move_down 20
    pdf.text titulo, :align => :center, :size => 14
    pdf.move_down 20
  end

  def find_current
    @orcamento = Orcamento.find(params[:id])
  end  
end
