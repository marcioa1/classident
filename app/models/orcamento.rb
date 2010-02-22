class Orcamento < ActiveRecord::Base
  belongs_to :paciente
  belongs_to :dentista
  belongs_to :paciente
  
  named_scope :do_paciente, lambda{|paciente_id| {:conditions=>['paciente_id = ?', paciente_id]}}
  named_scope :ultimo_codigo, :order=>["numero DESC"]

  def self.proximo_numero(paciente_id)
    maior_codigo = Orcamento.do_paciente(paciente_id).ultimo_codigo.last
    if maior_codigo.nil?
      return 1
    else
      return maior_codigo.numero + 1
    end
  end
end
