class SenhasController < ApplicationController
  layout "adm"
  
  def valida_senha
    retorno =  (params[:senha_digitada] == Senha.senha_cadastrada(
                                              session[:action],
                                              session[:clinica_id]) )
    session[:senha_digitada] = params[:senha_digitada] if retorno
    render :json=>retorno.to_json
  end
  
  def cadastra
    @senha = Senha.find_by_action_and_clinica_id(params[:action],session[:clinica_id])
    if @senha.nil?
      @senha = Senha.new
      @senha.action      = params[:action]
      @senha.senha       = params[:senha]
      @senha.clinica_id  = session[:clinica_id]
    end
  end
  
  def salva
    if Senha.find_by_action_and_clinica_id(params[:action],session[:clinica_id])
      @senha = Senha.find_by_action_and_clinica_id(params[:action],session[:clinica_id])
      @senha.senha = params[:nova_senha]
      if @senha.save
        redirect_to :back
      end
    else
      @senha             = Senha.new()  
      @senha.action      = params[:action_name]
      @senha.clinica_id  = session[:clinica_id]
      if @senha.save
        redirect_to :back
      else
        render :cadastra
      end
    end
  end
  
end
