class Tratamento < ActiveRecord::Base
  belongs_to :paciente
  belongs_to :item_tabela
  belongs_to :dentista
  named_scope :do_paciente, lambda{|paciente_id| {:conditions=>["paciente_id = ? ", paciente_id]}}
end
