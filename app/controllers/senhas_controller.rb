class SenhasController < ApplicationController
  def valida_senha
    retorno =  (params[:senha_digitada] == Senha.senha(params[:controller_name], params[:action_name], session[:clinica_id])) ? true : false
 debugger
    render :json=>retorno.to_json
  end
end
