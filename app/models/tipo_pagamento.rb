class TipoPagamento < ActiveRecord::Base
  acts_as_audited
  has_many :pagamentos
  
  validates_presence_of :nome
  
  named_scope :por_nome ,:order=>["ativo DESC, nome ASC"]
  named_scope :que_iniciam_com, lambda{|iniciais|{:conditions=>["nome like '?%'", iniciais]}}
  named_scope :da_clinica, lambda{|clinica_id| {:conditions=>["clinica_id=?", clinica_id]}}
  named_scope :ativos, :conditions=>["ativo = ?", true]
  named_scope :inativos, :conditions=>["ativo = ?", false]
  
end
