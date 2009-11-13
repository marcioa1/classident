class Preco < ActiveRecord::Base
  belongs_to :item_tabela
  
  named_scope :valor, lambda {|item_id,clinica_id| {
       :conditions=>["item_tabela_id = ? and clinica_id = ?", item_id, clinica_id]}}
end
