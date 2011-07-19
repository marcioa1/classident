class PacientesController < ApplicationController
  layout "adm"
  before_filter :require_user
  before_filter :busca_paciente, :only =>[:edit, :show, :update, :imprime_tratamento]
  before_filter :busca_tabelas
  
  def index
    @pacientes = Paciente.all
  end

  def show
  end

  def new
    if @clinica_atual.administracao?
      redirect_to administracao_path
    else
      @paciente      = Paciente.new(:inicio_tratamento => Date.current)
    end
  end

  def edit
    # @indicacoes = Indicacao.por_descricao.collect{|obj| [obj.descricao, obj.id]}
  end

  def create
    @paciente                   = Paciente.new(params[:paciente])
    @paciente.nome              = params[:paciente][:nome].nome_proprio
    @paciente.clinica_id        = session[:clinica_id]
    @paciente.codigo            = @paciente.gera_codigo(session[:clinica_id])
    @paciente.data_da_suspensao_da_cobranca_de_orto = params[:datepicker3].to_date unless params[:datepicker3].blank?
    @paciente.data_da_saida_da_lista_de_debitos     = params[:datepicker4].to_date unless params[:datepicker4].blank?
    if @paciente.save
      Rails.cache.write(@paciente.id.to_s, @paciente, :expires_in => 2.minutes) 
      redirect_to(abre_paciente_path(@paciente)) 
    else
      render :action => "new" 
    end
  end

  def update
    if @paciente.frozen?
      @paciente = Paciente.find(params[:id])
    end
    params[:paciente][:nome] = params[:paciente][:nome].nome_proprio
    if @paciente.update_attributes(params[:paciente])
      Rails.cache.write(@paciente.id.to_s, @paciente, :expires_in => 2.minutes) 
      redirect_to(abre_paciente_path(:id=>@paciente.id)) 
    else
      # render :edit
      #FIXME Verificar validação de email e redirecionar para o _edit
      render :partial=>"edit"
    end
  end

  def destroy
    @paciente.destroy

    redirect_to(pacientes_url) 
  end
  
  def pesquisa
    session[:paciente_id] = nil
    @pacientes = []
    if !params[:codigo].blank?
      if @clinica_atual.administracao?
        @pacientes = Paciente.all(:conditions=>["codigo=?", params[:codigo]], :order=>:nome)
      else
        @pacientes = Paciente.all(:conditions=>["clinica_id=? and codigo=?", session[:clinica_id].to_i, params[:codigo].to_i],:order=>:nome)
      end
      if !@pacientes.empty?
        if @pacientes.size==1
          redirect_to abre_paciente_path(:id=>@pacientes.first.id)
        end 
      else
        flash[:notice] =  'Não foi encontrado paciente com o código ' + params[:codigo]
        render :action=> "pesquisa"
      end
    end 
  end
  
  
  def pesquisa_nomes
    if @clinica_atual.administracao?
      nomes = Paciente.all(:select=>'nome,clinica_id', :conditions=>["nome like ?", "#{params[:term]}%" ])  
    else
      nomes = Paciente.all(:select=>'nome,clinica_id', :conditions=>["nome like ? and clinica_id = ? ", "#{params[:term].nome_proprio}%", session[:clinica_id] ])  
    end
    result = []
    nomes.each do |pac|
      if @clinica_atual.administracao?
        result << pac.nome + ', ' + Clinica.find(pac.clinica_id).sigla
      else
        result << pac.nome 
      end      
    end
    render :json => result.to_json
  end
  
  def abre
    # raise params.inspect
    if params[:nome]
      nome_sem_clinica = params[:nome].split(',')[0].strip
      if @clinica_atual.administracao?
        clinica_id = Clinica.find_by_sigla(params[:nome].split(',')[1].strip)
      else
        clinica_id = session[:clinica_id]
      end
      @paciente = Paciente.find_by_nome_and_clinica_id(nome_sem_clinica, clinica_id)
      Rails.cache.write(@paciente.id.to_s, @paciente, :expires_in => 2.minutes) 
    else
      @paciente =  Paciente.busca_paciente(params[:id])
    end
    session[:origem] = abre_paciente_path(@paciente.id)
    # @indicacoes             = Indicacao.por_descricao.collect{|obj| [obj.descricao, obj.id]}
    session[:paciente_id]   = @paciente.id
    session[:paciente_nome] = @paciente.nome
  end
  
  def nova_alta
    @alta = Alta.new(:paciente_id => id)
  end
  
  def create_alta
    
  end
  
  def nomes_que_iniciam_com
    if params[:nome]
      if @clinica_atual.administracao?
        @pacientes = Paciente.all(:conditions=>["nome like ?", params[:nome] + '%'],:order=>:nome)
      else
        @pacientes = Paciente.all(:conditions=>["clinica_id= ? and nome like ?", session[:clinica_id].to_i, params[:nome] + '%'],:order=>:nome)
      end
    end 
    result = ''
    @pacientes.each do |pac|
      result += '<a href= "#" onclick="javascript:escolheu_nome_da_lista(\''+pac.nome+'\',' + '\'' + params[:div] + '\',' + pac.id.to_s + ')" >'+ pac.nome + "</a><br/>"
    end
    result += ''
    render :json => result.to_json
  end

  def busca_id_do_paciente
    paciente_id = Paciente.find_by_nome_and_clinica_id(params[:nome], session[:clinica_id]).id
    render :json => paciente_id.to_json
  end

  def busca_paciente
    @paciente = Paciente.busca_paciente(params[:id])
  end  

  def busca_tabelas
    @tabelas        = Tabela.ativas.da_clinica(session[:clinica_id]).collect{|obj| [obj.nome,obj.id]}
    @indicacoes     = Indicacao.por_descricao.collect{|obj| [obj.descricao, obj.id]}
    @ortodontistas  = Clinica.find(session[:clinica_id]).ortodontistas.collect{|obj| [obj.nome,obj.id]}
  end
  
  def extrato_pdf
    require "prawn/layout"
    require "prawn/core"
    Prawn::Document.generate("public/relatorios/extrato.pdf") do |pdf|

      pdf.font "Times-Roman"
      imprime_cabecalho(pdf)
      pdf.text "Extrato", :size=>22, :align=>:center
      pdf.move_down 10
      @paciente = busca_paciente()
      pdf.text " Paciente : #{@paciente.nome}"
      pdf.move_down 10
      saldo = 0.0
      items = @paciente.extrato.map do |item|
        if item.is_a?(Debito)
          saldo -= item.valor
          [item.data.to_s_br, item.descricao.tira_acento, '', item.valor.real.to_s, saldo.real.to_s ]
        else
          saldo += item.valor
          [item.data.to_s_br,  item.observacao.tira_acento, item.valor.real.to_s, '', saldo.real.to_s]
        end
      end
      pdf.table(items,
            :row_colors =>['FFFFFF', 'DDDDDD'],
            :header_color => 'AAAAAA',
            :headers => ['Data', 'Observação', 'Débito', 'Crédito', 'Saldo'],
            :align => {0=>:center, 1=>:left, 2=>:right, 3=>:right, 4=>:right},
            :cell_style => { :padding => 12 }, :width => 400)

    end
    head :ok
  end
  
  def verifica_nome_do_paciente
    paciente = Paciente.find_by_nome( params[:nome])
    if paciente
      paciente.complemento = paciente.clinica.nome
      render :json => paciente.to_json
    else
      head :bad_request
    end
  end
  
  def transfere_paciente
    paciente                 = Paciente.find(params[:id])
    paciente.clinica_id      = session[:clinica_id]
    paciente.codigo_anterior = paciente.codigo_anterior && paciente.codigo_anterior + '/' + paciente.codigo + "( #{paciente.clinica.nome})"
    novo_codigo              = paciente.gera_codigo(session[:clinica_id])
    paciente.codigo          = novo_codigo 
    if paciente.save
      render :json => paciente.nome.to_json
    else
      head :bad_request
    end
  end

  def altera_cep
    Paciente.find(params[:id]).update_attribute('cep', params[:cep])
    head :ok
  end  
  
  def imprime_tratamento
    require 'prawn/core'
    require "prawn/layout"
    require 'iconv'

    Prawn::Document.generate("public/relatorios/#{session[:clinica_id]}/tratamento.pdf") do |pdf|
      pdf.repeat :all do
        pdf.image "public/images/logo-print.jpg", :align => :left, :vposition => -20
        pdf.bounding_box [10, 700], :width  => pdf.bounds.width do
          pdf.font "Helvetica"
          pdf.text 'Orçamento', :align => :center, :size => 14, :vposition => -20
        end
      end
    
      pdf.move_down 20
      pdf.text "Paciente : #{@paciente.nome}", :size=>14
      pdf.move_down 36
      # dados = Array.new()
      dados = 'dente,face,código,descrição,valor,dentista,data,orçamento'.split(',')
      # pdf.text Iconv.conv('latin1','utf8','áéíóú')      
      dados = @paciente.tratamentos.map do |t|
        [
          t.dente,
          t.face,
          t.item_tabela && t.item_tabela.codigo ,
          Iconv.conv('latin1', 'utf8', t.descricao),
          t.valor.real.to_s,
          t.dentista.nome,
          t.data.to_s_br,
          t.orcamento.numero.to_s
        ]
      end
debugger
    pdf.table(  dados, :header => false) do
      row(0).style(:font_style => :bold, :background_color => 'cccccc')
    end


    end
    
  end
  
end
