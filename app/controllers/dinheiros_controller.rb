class DinheirosController < ApplicationController
  def entrada
  end
  
  def index
    @mes = Date.month
    @entradas = Dinheiro.do_mes(@mes).da_clinica(session[:clinica_id])
  end

  def relatorio
  end

end
