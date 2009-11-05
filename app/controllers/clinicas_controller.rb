class ClinicasController < ApplicationController
  
  def selecionou_clinica
    debugger
    if params[:clinica_id]=="Administração"
      session[:clinica] = "Administração"
      redirect_to :back
    else
      session[:clinica] = Clinica.find(params[:clinica_id]).nome
      redirect_to pesquisa_pacientes_path
    end
    
#    render => :nothing  
  end
  
end
