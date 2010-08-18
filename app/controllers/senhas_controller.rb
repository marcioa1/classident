class SenhasController < ApplicationController
  layout "adm"
  def valida_senha
    retorno =  (params[:senha_digitada] == Senha.senha(params[:controller_name], params[:action_name], session[:clinica_id])) ? true : false
    render :json=>retorno.to_json
  end
  
  def new
    @senha = Senha.new
    @senha.controller_name = params[:controller_name]
    @senha.action_name     = params[:action_name]
  end
  
  def create
    @senha            = Senha.new(params[:senha])  
    @senha.clinica_id = session[:clinica_id]
    if @senha.save
      redirect_to :back
    else
      render :new
    end
  end
  
end
