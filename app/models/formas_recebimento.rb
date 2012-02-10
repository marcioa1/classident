class FormasRecebimento < ActiveRecord::Base
  acts_as_audited
  has_many :recebimentos
  
  named_scope :ativas, :conditions => [ 'ativo = ?', true]
  named_scope :cheque, :conditions=>["tipo = 'C'"]
  named_scope :dinheiro_ou_cheque, :conditions=>["tipo in ('C','D')"]
  named_scope :outras_formas, :conditions=>["tipo not in ('C' 'D')"]
  named_scope :por_nome ,:order=>:nome
  
  def self.cheque_id
    FormasRecebimento.find_by_nome("cheque").id
  end
  
end
