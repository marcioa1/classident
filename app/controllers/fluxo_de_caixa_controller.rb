class FluxoDeCaixaController < ApplicationController
  
  layout "adm"
  
  before_filter :require_user
  before_filter :salva_action_na_session
  before_filter :verifica_se_tem_senha
  
  def index
    session[:origem] = '/fluxo_de_caixa'
    @fluxo           = FluxoDeCaixa.atual(session[:clinica_id])
    if @fluxo.nil?
      FluxoDeCaixa.create(:clinica_id=>session[:clinica_id], :data=>Date.today, :saldo_em_dinheiro=>0.0, :saldo_em_cheque=>0.0)
      @fluxo = FluxoDeCaixa.da_clinica(session[:clinica_id]).first
    end
    if params[:data]
      @data = params[:data].to_date
      if @fluxo.data > params[:data].to_date
        @fluxo = FluxoDeCaixa.voltar_para_a_data(params[:data].to_date, session[:clinica_id])
      else
        @fluxo = FluxoDeCaixa.avancar_um_dia(session[:clinica_id],
             params[:saldo_dinheiro], params[:saldo_cheque]) if params[:saldo_dinheiro]
      end
    else
      @data = @fluxo.data
    end
    if @clinica_atual.administracao?
      @recebimentos = []
      @cheques      = Cheque.por_bom_para.na_administracao.
               entre_datas(@fluxo.data,@fluxo.data).nao_excluidos
      @entradas     = Entrada.entrada_na_administracao.do_dia(@data).nao_e_resolucao_de_cheque.confirmado
      @remessas     = Entrada.remessa_da_administracao.do_dia(@data)
    else
      @entradas     = Entrada.entrada_na_clinica(session[:clinica_id]).do_dia(@data).confirmado#.da_clinica(session[:clinica_id])
      @remessas     = Entrada.da_clinica(session[:clinica_id]).entrada_na_administracao.do_dia(@data).nao_e_resolucao_de_cheque
      # @remessas     = Entrada.remessas(@data, session[:clinica_id]) || []
      @recebimentos = Recebimento.da_clinica(session[:clinica_id]).no_dia(@fluxo.data).nao_excluidos #.nas_formas(FormasRecebimento.dinheiro_ou_cheque)
      @cheques      = []
    end

    @pagamentos   = Pagamento.da_clinica(session[:clinica_id]).no_dia(@fluxo.data).no_livro_caixa.nao_excluidos.nao_sendo_transferencia
    @lancamentos  = @recebimentos + @pagamentos + @entradas + @remessas + @cheques
    @entradas_adm = []
    # if @clinica_atual.administracao?
    #   @entradas_adm = Entrada.confirmado.do_dia(@fluxo.data).nao_e_resolucao_de_cheque
    #   @entradas_adm.each do |entrada| 
    #     entrada.valor *= -1
    #   end
    #   @lancamentos += @entradas_adm 
    # end
  end
  
  def fechamento_de_mes
    
  end
  
  def conserta_saldo
    if !current_user.master? 
      render  :nothing
    else
      @clinicas = Clinica.da_classident.collect{|obj| [obj.nome, obj.id]}
    end
  end
  
  def busca_saldo
    fluxo = FluxoDeCaixa.da_clinica(params[:clinica]).last
    result = (fluxo.data.to_s_br + ';' + fluxo.saldo_em_dinheiro.real.to_s + ';' + fluxo.saldo_em_cheque.real.to_s)
    render :json => result.to_json
  end
  
  def grava_saldo
    clinica  = params[:clinica]
    dinheiro = params[:saldo_em_dinheiro].gsub('.','').gsub(',', '.').to_f
    cheque   = params[:saldo_em_cheque].gsub('.','').gsub(',', '.').to_f
    fluxo    = FluxoDeCaixa.da_clinica(clinica).last
    fluxo.saldo_em_dinheiro = dinheiro
    fluxo.saldo_em_cheque   = cheque
    fluxo.save
    redirect_to conserta_saldo_path
  end
  
end
