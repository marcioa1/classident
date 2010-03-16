class FluxoDeCaixaController < ApplicationController
  
  layout "adm"
  
  before_filter :require_user
  
  def index
    @fluxo = FluxoDeCaixa.da_clinica(session[:clinica_id]).last
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
  end
end
