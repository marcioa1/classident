class Senha < ActiveRecord::Base
  def self.senha(controller, action, clinica_id)
    registro = Senha.find_by_controller_and_action_and_clinica_id(controller, action,clinica_id)
    registro && registro.senha
  end
end
