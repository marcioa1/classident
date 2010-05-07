class FluxoDeCaixaController < ApplicationController
  
  layout "adm"
  
  before_filter :require_user
  
  def index
    @fluxo = FluxoDeCaixa.da_clinica(session[:clinica_id]).last
    if @fluxo.nil?
      FluxoDeCaixa.create(:clinica_id=>session[:clinica_id], :data=>Date.today, :saldo_em_dinheiro=>0.0, :saldo_em_cheque=>0.0)
      @fluxo = FluxoDeCaixa.first
    end
    if params[:data]
      if @fluxo.data > params[:data].to_date
        @fluxo = @fluxo.voltar_para_a_data(params[:data].to_date, session[:clinica_id])
      else
        @fluxo = @fluxo.avancar_um_dia(session[:clinica_id],params[:data].to_date,
             params[:saldo_dinheiro], params[:saldo_cheque])
      end
    end
    @recebimentos = Recebimento.da_clinica(session[:clinica_id]).no_dia(@fluxo.data).nao_excluidos
    @pagamentos = Pagamento.da_clinica(session[:clinica_id]).no_dia(@fluxo.data).no_livro_caixa
    @entradas = Entrada.entrada.da_clinica(session[:clinica_id]).do_dia(@fluxo.data)
    @remessas = Entrada.remessa.da_clinica(session[:clinica_id]).do_dia(@fluxo.data)
    @lancamentos = @recebimentos + @pagamentos + @entradas + @remessas 
    @entradas_adm =[]
    if administracao?
      @entradas_adm = Entrada.confirmado.do_dia(@fluxo.data)
      @entradas_adm.each do |entrada| 
        entrada.valor *= -1
      end
      @lancamentos += @entradas_adm if administracao?
    end
  end
end
