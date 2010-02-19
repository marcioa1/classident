module AdministracaoHelper
  def administracao?
    session[:clinica_id].to_i ==0
  end
end
