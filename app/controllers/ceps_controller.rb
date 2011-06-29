class CepsController < ApplicationController

  def busca_pelo_logradouro
    cep = Cep.find(:all, 
                   :conditions=>['logradouro LIKE ?', params[:logradouro] + '%' ],
                   :order => 'cidade, bairro'
    )
    if cep.size == 1
      render :json => cep.first.cep.to_json
    else
      render :partial => '/ceps/ceps', :locals => {:ceps => cep}
    end
  end

end
