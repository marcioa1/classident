class TabelaProtetico < ActiveRecord::Base
  acts_as_audited
  belongs_to :protetico
  has_many   :trabalho_proteticos
  
  named_scope :por_descricao, :order=>:descricao
  named_scope :tabela_base , :conditions=>["protetico_id IS NULL"]
  
  attr_accessor :valor_br

  validates_presence_of :descricao, :message => "A descrição é obrigatória"
  # validates_numericality_of :valor_br, :only => [:create, :update], :message => "não numérico"
  
  
  def valor_br
    self.valor_br = self.valor.real  
  end
  
  def valor_br=(new_value='0')
    valor_br = new_value
    self.valor = valor_br.to_s.gsub('.','').sub(',','.')
  end
end
