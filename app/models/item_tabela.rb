class ItemTabela < ActiveRecord::Base
  belongs_to :tabela
  has_many :precos
  
  
end
