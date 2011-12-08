class Protetico < ActiveRecord::Base
  acts_as_audited
  has_many   :tabela_proteticos
  belongs_to :clinica
  has_many   :trabalho_proteticos
  has_many   :pagamentos
  
  
  named_scope :ativos, :conditions => ['ativo = ? ', true]
  named_scope :da_classident, :conditions=>["clinica_id < 8"]
  named_scope :da_clinica, lambda {|clinica_id| {:conditions=>["proteticos.clinica_id = ?", clinica_id]}}
  named_scope :inativos, :conditions => ['ativo = ?', false]
  named_scope :por_nome, :order=>:nome
  named_scope :com_trabalhos_entregues_e_nao_pagos, 
     :include => :trabalho_proteticos, 
     :conditions=>['trabalho_proteticos.pagamento_id IS NULL and ((data_de_devolucao IS NOT NULL and data_de_repeticao IS NULL) or (data_de_repeticao IS NOT NULL and data_de_devolucao_da_repeticao IS NOT NULL))']
end
