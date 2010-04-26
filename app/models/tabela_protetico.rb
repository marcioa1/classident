class TabelaProtetico < ActiveRecord::Base
  belongs_to :protetico
  has_many   :trabalho_proteticos
  
  named_scope :por_descricao, :order=>:descricao
  named_scope :tabela_base , :conditions=>["protetico_id IS NULL"]
  
  validates_numericality_of :valor, :only => [:create, :update], :message => "não numérico"
end
