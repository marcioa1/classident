class CepsController < ApplicationController

  def busca_pelo_logradouro
    cep = Cep.find(:all, :conditions=>['logradouro LIKE ?', params[:logradouro] + '%' ])
    render :json => cep.first.cep.to_json
  end

end
