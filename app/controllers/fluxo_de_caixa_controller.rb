class FluxoDeCaixaController < ApplicationController
  
  layout "adm"
  
  def index
    @fluxo = FluxoDeCaixa.da_clinica(session[:clinica_id]).last
    debugger
    if params[:data]
      if @fluxo.data > params[:data].to_date
        @fluxo = @fluxo.voltar_para_a_data(params[:data].to_date, session[:clinica_id])
      else
        @fluxo = @fluxo.avancar_um_dia
      end
    end
    @recebimentos = Recebimento.da_clinica(session[:clinica_id]).no_dia(@fluxo.data)
    @pagamentos = Pagamento.da_clinica(session[:clinica_id]).no_dia(@fluxo.data)
    @lancamentos = @recebimentos + @pagamentos
    debugger
  end
end
#TODO fazer fluxo de caixa
