class FormasRecebimento < ActiveRecord::Base
  acts_as_audited
  has_many :recebimentos
  
  named_scope :por_nome ,:order=>:nome
end
