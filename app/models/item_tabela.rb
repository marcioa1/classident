class ItemTabela < ActiveRecord::Base
  acts_as_audited
  belongs_to    :tabela
  has_many      :precos
  has_many      :tratamentos
  belongs_to    :descricao_conduta
  belongs_to    :tabela
  
  validates_presence_of :tabela_id, :codigo, :descricao, :dias_de_retorno
  # validates_numericality_of :dias_de_retorno, :greater_than_or_equal_to => 0
  
  def preco_na_clinica()
    registro = Preco.find_by_clinica_id_and_item_tabela_id(self.tabela.clinica_id,self.id)
    return registro.preco    
  end
  
end
