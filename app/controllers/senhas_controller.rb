class SenhasController < ApplicationController
  layout "adm"
  
  def valida_senha
    senha_da_action = Senha.senha(params[:controller_name], params[:action_name], session[:clinica_id]) 
    retorno =  (params[:senha_digitada] == senha_da_action) ? true : false
    session[:senha_digitada] = params[:senha_digitada] if retorno
    render :json=>retorno.to_json
  end
  
  def cadastra
    @senha = Senha.find_by_controller_name_and_action_name_and_clinica_id(params[:controller_name], params[:action_name],session[:clinica_id])
    if @senha.nil?
      @senha = Senha.new
      @senha.controller_name = params[:controller_name]
      @senha.action_name     = params[:action_name]
      @senha.clinica_id      = session[:clinica_id]
    end
  end
  
  def salva
    if Senha.find_by_controller_name_and_action_name_and_clinica_id(params[:controller_name], params[:action_name],session[:clinica_id])
      @senha = Senha.find_by_controller_name_and_action_name_and_clinica_id(params[:controller_name], params[:action_name],session[:clinica_id])
      @senha.senha = params[:nova_senha]
      if @senha.save
        redirect_to :back
      end
    else
      @senha                 = Senha.new()  
      @senha.controller_name = params[:controller_name]
      @senha.action_name     = params[:action_name]
      @senha.clinica_id      = session[:clinica_id]
      if @senha.save
        redirect_to :back
      else
        render :cadastra
      end
    end
  end
  
end
