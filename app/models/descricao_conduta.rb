class DescricaoConduta < ActiveRecord::Base
  has_many :item_tabelas
  
  validates_presence_of :descricao,  :message => "Não pode ser vazio."
end
