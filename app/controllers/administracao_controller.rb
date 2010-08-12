class AdministracaoController < ApplicationController
  layout"adm"
  
  def index
  end

  def salva_tab_do_paciente
    session[:tab_paciente] = params[:tab_index] 
    render :nothing => true
  end
  
end
