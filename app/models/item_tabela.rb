class ItemTabela < ActiveRecord::Base
  belongs_to :tabela
  has_many :precos
  has_many :tratamentos
  
end
