class ClinicasController < ApplicationController
  
  def selecionou_clinica
    session[:clinica_id] = params[:clinica_id]
    @clinica_atual = Clinica.find(params[:clinica_id])
    if @clinica_atual.e_administracao
      redirect_to administracao_path
    else  
      redirect_to pesquisa_pacientes_path
    end
  end
  
end
