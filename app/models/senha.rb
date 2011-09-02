class Senha < ActiveRecord::Base
  def self.senha_cadastrada(action, clinica_id)
    registro = Senha.find_by_action_and_clinica_id(action, clinica_id)
    registro && registro.senha
  end
end
