class FluxoDeCaixaController < ApplicationController
  
  layout "adm"
  
  before_filter :require_user
  before_filter :salva_action_na_session
  before_filter :verifica_se_tem_senha
  
  def index
    @fluxo          = FluxoDeCaixa.atual(session[:clinica_id])
    @fluxo_de_ontem = FluxoDeCaixa.da_clinica(session[:clinica_id]).saldo_na_data(@fluxo.data - 1.day).first
    if @fluxo.nil?
      FluxoDeCaixa.create(:clinica_id=>session[:clinica_id], :data=>Date.today, :saldo_em_dinheiro=>0.0, :saldo_em_cheque=>0.0)
      @fluxo = FluxoDeCaixa.da_clinica(session[:clinica_id]).first
    end
    if params[:data]
      if @fluxo.data > params[:data].to_date
        @fluxo = FluxoDeCaixa.voltar_para_a_data(params[:data].to_date, session[:clinica_id])
      else
        @fluxo = FluxoDeCaixa.avancar_um_dia(session[:clinica_id],
             params[:saldo_dinheiro], params[:saldo_cheque])
      end
    end
    if @administracao
      @recebimentos = []
      @cheques      = Cheque.por_bom_para.na_administracao.
               entre_datas(@fluxo.data,@fluxo.data).nao_excluidos
    else
      @recebimentos = Recebimento.da_clinica(session[:clinica_id]).no_dia(@fluxo.data).nao_excluidos
      @cheques      = []
    end
    @pagamentos   = Pagamento.da_clinica(session[:clinica_id]).no_dia(@fluxo.data).no_livro_caixa
    @entradas     = Entrada.entrada.da_clinica(session[:clinica_id]).do_dia(@fluxo.data)
    @remessas     = Entrada.remessa.da_clinica(session[:clinica_id]).do_dia(@fluxo.data)
    @lancamentos  = @recebimentos + @pagamentos + @entradas + @remessas + @cheques
    @entradas_adm = []
    if @administracao
      @entradas_adm = Entrada.confirmado.do_dia(@fluxo.data)
      @entradas_adm.each do |entrada| 
        entrada.valor *= -1
      end
      @lancamentos += @entradas_adm 
    end
  end
  
  
  def conserta_saldo
    if !current_user.master? 
      render  :nothing
    else
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
