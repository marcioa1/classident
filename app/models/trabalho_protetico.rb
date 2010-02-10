class TrabalhoProtetico < ActiveRecord::Base
  belongs_to :paciente
  belongs_to :dentista
  belongs_to :tabela_protetico
  belongs_to :protetico
  belongs_to :clinica
  
  named_scope :pendentes, :conditions=>["data_de_devolucao IS NULL"]
  named_scope :devolvidos, :conditions=>["data_de_devolucao NOT NULL"]
  named_scope :do_paciente, lambda {|paciente_id| 
            {:conditions=>["paciente_id = ? ", paciente_id]}}
  named_scope :do_protetico, lambda {|protetico_id| 
            {:conditions=>["protetico_id = ? ", protetico_id]}}
  named_scope :da_clinica, lambda {|clinica_id| 
            {:conditions=>["clinica_id = ? ", clinica_id]}}
end
