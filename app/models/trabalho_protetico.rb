class TrabalhoProtetico < ActiveRecord::Base
  belongs_to :paciente
  belongs_to :dentista
  belongs_to :tabela_protetico
  
  named_scope :pendentes, :conditions=>["data_de_devolucao IS NULL"]
  named_scope :do_paciente, lambda {|paciente_id| 
            {:conditions=>["paciente_id = ? ", paciente_id]}}
end
