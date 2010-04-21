class Tabela < ActiveRecord::Base
  has_many   :item_tabelas
  has_many   :pacientes
  belongs_to :clinica
  
  named_scope :ativas, :conditions=>["ativa='t'"]
  named_scope :da_clinica, lambda { |clinica_id| {:conditions => ['clinica_id = ? ', clinica_id]}}
  named_scope :por_nome, :order=>:nome
end
