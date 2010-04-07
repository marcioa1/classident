class TipoPagamento < ActiveRecord::Base
  has_many :pagamentos
  validates_presence_of :nome
  named_scope :por_nome ,:order=>["ativo DESC, nome ASC"]
  named_scope :da_clinica, lambda{|clinica_id| {:conditions=>["clinica_id=?", clinica_id]}}
  named_scope :ativos, :conditions=>["ativo = ?", true]
  def ativo?
    ativo!=0
  end
end
