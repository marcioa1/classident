class CepsController < ApplicationController

  def busca_pelo_logradouro
    logradouro = params[:logradouro].upcase.strip  + '%'
    cep = Cep.find(:all, 
                   :conditions=>['logradouro LIKE ?', logradouro ],
                   :order => 'cidade, bairro'
    )
    render :partial => '/ceps/ceps', :locals => {:ceps => cep}
  end

end
