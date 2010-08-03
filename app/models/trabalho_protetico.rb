class TrabalhoProtetico < ActiveRecord::Base
  acts_as_audited
  belongs_to :paciente
  belongs_to :dentista
  belongs_to :tabela_protetico
  belongs_to :protetico
  belongs_to :clinica
  belongs_to :cheque
  belongs_to :tratamento
  
  named_scope :da_clinica, lambda {|clinica_id| 
            {:conditions=>["trabalho_proteticos.clinica_id = ? ", clinica_id]}}
  named_scope :devolvidos, :conditions=>["data_de_devolucao IS NOT NULL"]
  named_scope :do_paciente, lambda {|paciente_id| 
            {:conditions=>["paciente_id = ? ", paciente_id]}}
  named_scope :do_protetico, lambda {|protetico_id| 
            {:conditions=>["protetico_id = ? ", protetico_id]}}
  named_scope :entre_datas, lambda{|inicio,fim| {:conditions=>["data_de_envio between ? and ? ", inicio,fim]}}
  named_scope :entregues, :conditions=>['(data_de_devolucao IS NOT NULL and data_de_repeticao IS NULL) or (data_de_repeticao IS NOT NULL and data_de_devolucao_da_repeticao IS NOT NULL)']
  named_scope :nao_pagos, :conditions=>['pagamento_id IS NULL']
  named_scope :pendentes, :conditions=>["data_de_devolucao IS NULL"]
  named_scope :por_protetico, :include=> :protetico, :order=>'proteticos.nome'
  
  def data_de_devolucao_final
    self.data_de_devolucao_da_repeticao.nil? ? self.data_de_devolucao : self.data_de_devolucao_da_repeticao
  end
end
