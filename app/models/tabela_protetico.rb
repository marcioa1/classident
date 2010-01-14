class TabelaProtetico < ActiveRecord::Base
  belongs_to :protetico
  named_scope :por_descricao, :order=>:descricao
  named_scope :tabela_base , :conditions=>["protetico_id IS NULL"]
end
