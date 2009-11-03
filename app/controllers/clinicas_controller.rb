class ClinicasController < ApplicationController
  
  def selecionou_clinica
    debugger
    if params[:clinica_id]=="Administração"
      session[:clinica] = "Administração"
    else
      session[:clinica] = Clinica.find(params[:clinica_id]).nome
    end
    redirect_to :back
#    render => :nothing  
  end
  
end
