class TipoPagamento < ActiveRecord::Base
  has_many :pagamentos
  validates_presence_of :nome
  named_scope :por_nome ,:order=>:nome
  named_scope :da_clinica, lambda{|clinica_id| {:conditions=>["clinica_id=?", clinica_id]}}
end
