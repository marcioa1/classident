module AdministracaoHelper
  def administracao?
    session[:clinica_id].to_i == 10
  end
end
