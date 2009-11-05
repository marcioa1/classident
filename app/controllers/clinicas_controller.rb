class ClinicasController < ApplicationController
  
  def selecionou_clinica
    debugger
    if params[:clinica_id]=="Administração"
      session[:clinica] = "Administração"
      session[:clinica_id] = 0
      redirect_to :back
    else
      session[:clinica] = Clinica.find(params[:clinica_id]).nome
      session[:clinica_id] = params[:clinica_id]
      redirect_to pesquisa_pacientes_path
    end
    
#    render => :nothing  
  end
  
end
