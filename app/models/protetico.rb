class Protetico < ActiveRecord::Base
  has_many :tabela_proteticos
  
  named_scope :por_nome, :order=>:nome
  
end
