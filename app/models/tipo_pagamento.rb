class TipoPagamento < ActiveRecord::Base
  has_many :pagamentos
  validates_presence_of :nome
  named_scope :por_nome ,:order=>:nome
end
