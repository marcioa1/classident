class Protetico < ActiveRecord::Base
  has_many   :tabela_proteticos
  belongs_to :clinicas
  has_many   :trabalho_proteticos
  has_many   :pagamentos
  
  named_scope :por_nome, :order=>:nome
  
end
