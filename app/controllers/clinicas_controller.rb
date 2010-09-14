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
      @data_inicial = Date.today - 15.days
      @data_final   = Date.today
    else
      @data_inicial = params[:datepicker].to_date if Date.valid?(params[:datepicker])
      @data_final   = params[:datepicker2].to_date if Date.valid?(params[:datepicker2])
    end
    @dentistas = Clinica.find(session[:clinica_id]).dentistas.por_nome
    @dentistas.each do |den|
      mensal = den.producao_entre_datas(@data_inicial,@data_final)
      if mensal.split("/")[1].to_f > 0.0
        @valores << (mensal + "/" + den.nome + '/' + den.id.to_s)
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
      @data_inicial = Date.new(Date.today.year,Date.today.month,1)
      @data_final   = Date.today
    else
      @data_inicial = params[:datepicker].to_date if Date.valid?(params[:datepicker])
      @data_final   = params[:datepicker2].to_date if Date.valid?(params[:datepicker2])
    end
    if @data_inicial.nil? || @data_final.nil?
      @altas = []
      @erro  = 'Data inválida.'
    else
      if params[:somente_em_alta]
        @altas = Alta.da_clinica(session[:clinica_id]).entre_datas(@data_inicial, @data_final).em_alta
      else
        @altas = Alta.da_clinica(session[:clinica_id]).entre_datas(@data_inicial, @data_final)
      end
    end
  end
  
  def abandono_de_tratamento
    params[:dias_sem_contato] = 90 if !params[:dias_sem_contato]
    params[:dias_tratamento] = 120 if !params[:dias_tratamento]
    pacientes               = Tratamento.pacientes_em_tratamento
    @dias                   = params[:dias_sem_contato] ? params[:dias_sem_contato].to_i : 90
    @dias_ultimo_tratamento = params[:dias_tratamento] ? params[:dias_tratamento].to_i : 120
    @ultima_data            = Date.today - @dias.days
    @primeira_data          = Date.today - @dias_ultimo_tratamento
    @abandonos              = []  
    pacientes.each do |pac|
      ultimo_tratamento = Tratamento.do_paciente(pac.paciente_id).entre(@primeira_data, @ultima_data).nao_excluido
      if !ultimo_tratamento.empty?
        paciente = Paciente.find(pac.paciente_id)
        @abandonos << {:id => pac.paciente_id, :nome => paciente.nome, 
                       :ultima_intervencao => ultimo_tratamento.first.data, :telefone => paciente.telefones }
      end
    end
  end
  
  def pacientes_de_ortodontia
    @pacientes = Paciente.da_clinica(session[:clinica_id]).de_ortodontia.por_nome
  end
  
  def fechamento_mes
    @abertura      = Array.new(13,0)
    @pagamento     = Array.new(13,0)
    @recebimento   = Array.new(13,0)
    @remessa       = Array.new(13,0)
    forma_dinheiro = FormasRecebimento.find_by_nome("Dinheiro")
    if params[:date].present?
      @data = Date.new(params[:date][:year].to_i,1,1)
      (1..12).each do |mes|
        data_inicial   = Date.new(params[:date][:year].to_i, mes,1)
        data_final     = data_inicial + 1.month - 1.day
        puts data_inicial.to_s_br + " / " + data_final.to_s_br
        fluxo          = FluxoDeCaixa.saldo_na_data(data_inicial).da_clinica(session[:clinica_id])
        @abertura[mes] = fluxo.first.saldo_em_dinheiro if !fluxo.empty?
        total          = Pagamento.da_clinica(session[:clinica_id]).entre_datas(data_inicial,data_final).
        no_livro_caixa.nao_excluidos.sum('valor_pago')
        terceiros      = Pagamento.da_clinica(session[:clinica_id]).entre_datas(data_inicial,data_final).
        no_livro_caixa.nao_excluidos.sum('valor_terceiros')
        @pagamento[mes]   = total - terceiros
        @recebimento[mes] = Recebimento.da_clinica(session[:clinica_id]).entre_datas(data_inicial,data_final).
        nao_excluidos.nas_formas(forma_dinheiro.to_a).sum('valor')
        @remessa[mes]     = Entrada.da_clinica(session[:clinica_id]).do_mes(data_inicial).sum('valor')
      end
    else
      @data = Date.today
    end
  end
  
  def relatorio_de_exclusao
    @clinicas    = Clinica.all.collect{|cl| [cl.nome, cl.id.to_s]}
    if !params[:data_inicial]
      quinzena
    else 
      @data_inicial = params[:data_inicial].to_date
      @data_final   = params[:data_final].to_date
    end
    @recebimentos_excluidos = Recebimento.all(:conditions=>['data_de_exclusao between ? and ? and clinica_id = ?', @data_inicial, @data_final, params[:clinica_id]])
    @pagamentos_excluidos   = Pagamento.all(:conditions=>['data_de_exclusao between ? and ? and clinica_id = ?', @data_inicial, @data_final, params[:clinica_id]])
  end
  
  def usuarios_da_clinica
    clinica = Clinica.find(params[:clinica_id])
    render :json => clinica.users.collect{|obj| [obj.id.to_s,obj.nome]}.to_json
  end
  
end
