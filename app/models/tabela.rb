class Tabela < ActiveRecord::Base
  has_many :item_tabelas
  has_many :pacientes
  
  named_scope :ativas, :conditions=>["ativa='t'"]
end
