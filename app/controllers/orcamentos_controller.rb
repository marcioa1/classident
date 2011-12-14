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
    @orcamento.recalcula_valor
    @dentistas = Clinica.find(session[:clinica_id]).dentistas.ativos.por_nome.collect{|obj| [obj.nome,obj.id]}
  end

  def create
    @orcamento                             = Orcamento.new(params[:orcamento])
    @orcamento.vencimento_primeira_parcela = params[:orcamento][:vencimento_primeira_parcela].to_date if Date.valid?(params[:orcamento][:vencimento_primeira_parcela])
    @orcamento.data_de_inicio              = params[:orcamento][:data_de_inicio].to_date if Date.valid?(params[:orcamento][:data_de_inicio])
    @orcamento.clinica_id                  = session[:clinica_id]
    if @orcamento.save
      Tratamento.associa_ao_orcamento(params[:tratamento_ids], @orcamento.id)
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
    @titulo = "Orçamentos elaborados entre #{params[:datepicker]} e #{params[:datepicker2]} "
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
    @clinicas = Clinica.todas.da_classident
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
 
  verify_existence_of_directory

  Prawn::Document.generate(File.join(Rails.root , "impressoes/#{session[:clinica_id]}/orcamento.pdf")) do |pdf|
    pdf.font_size = 12
    pdf.draw_text "Paciente", :at => [1, 640]
    pdf.draw_text ": #{@orcamento.paciente.nome}", :at => [70,640]
    pdf.draw_text "Dentista", :at => [1, 620]
    pdf.draw_text ": #{@orcamento.dentista.nome}", :at => [70,620]
    pdf.draw_text "Data", :at => [380, 620]
    pdf.draw_text ": #{@orcamento.data.to_s_br}", :at => [420,620]

    pdf.font_size = 10
    y = 570
    pdf.draw_text "Dente", :at=>[2,y]
    pdf.draw_text "Faces", :at => [40,y] 
    pdf.draw_text "Conduta" , :at => [120, y]
    pdf.draw_text "Descrição" , :at => [200, y]
    pdf.draw_text "Valor" , :at => [500, y]
    y -= 12
    pdf.horizontal_line 1, 30, :at => y+7
    pdf.horizontal_line 40, 70, :at => y+7
    pdf.horizontal_line 120, 150, :at => y+7
    pdf.horizontal_line 200, 400, :at => y+7
    pdf.horizontal_line 480, 530, :at => y+7
    pdf.stroke
    y -= 5
    @orcamento.tratamentos.each do |trat|
      pdf.draw_text trat.dente, :at=> [2,y]
      pdf.draw_text trat.face, :at=> [40,y]
      pdf.draw_text trat.item_tabela.present? ? trat.item_tabela.codigo : "", :at=> [120,y]
      pdf.draw_text trat.descricao.gsub(/[^a-z0-9.:,$ ]/i,'.'), :at=> [200,y]
      pdf.bounding_box([480, y+7], :width => 50, :height => 12) do
        pdf.text trat.valor.real.to_s, :align => :right
      end

      y -= 12
    end
    pdf.horizontal_line 480, 530, :at => y+7
    pdf.stroke
    y -= 5
    pdf.bounding_box([480, y+7], :width => 50, :height => 12) do
      pdf.text @orcamento.valor.real.to_s, :align => :right
    end

    y -= 20
    pdf.draw_text "Forma de pagamento ", :at => [10, y]
    if @orcamento.a_vista?
      pdf.draw_text ": Dinheiro, pagamento de acordo c/ a realização do tratamento.", :at => [120, y]
      y -= 12
    else
      pdf.draw_text ": #{@orcamento.forma_de_pagamento}", :at => [120, y]
      y -= 12
      pdf.draw_text "Número de parcelas", :at => [10, y]
      pdf.draw_text ": #{@orcamento.numero_de_parcelas}", :at => [120, y]
      y -= 12
      pdf.draw_text "Valor da parcela", :at => [10, y]
      pdf.draw_text ": #{@orcamento.valor_da_parcela.real}", :at => [120, y]
      y -= 12
      pdf.draw_text "Dia de vencimento", :at => [10, y]
      pdf.draw_text ": #{@orcamento.vencimento_primeira_parcela.day.to_s}", :at => [120, y]
      y -= 12
      pdf.draw_text "Primeira parcela", :at => [10, y]
      pdf.draw_text ": #{@orcamento.vencimento_primeira_parcela.to_s_br}", :at => [120, y]
      y -= 12
    end


    # pdf.move_down 18
    # pdf.text "Explicações"
    # cabe = [['código(s)' , 'Explicações']]
    # pdf.table(cabe + @orcamento.explicacoes.to_a) do
    #   row(0).style(:font_style => :bold, :background_color => 'cccccc')
    #   column(4).style(:align=>:right)
    # end

    # pdf.text @orcamento.explicacoes.inspect
  end
    send_file File.join(RAILS_ROOT , "impressoes/#{session[:clinica_id]}/orcamento.pdf")
  end

  def imprime_cabecalho(pdf, titulo)
    # pdf.image "public/images/logo-print.jpg", :align => :left
    pdf.text "#{Time.current.to_s_br}", :align => :right, :size=>8
    pdf.move_down 20
    pdf.text titulo, :align => :center, :size => 14
    pdf.move_down 20
  end

  def find_current
    @orcamento = Orcamento.find(params[:id])
  end  
end
