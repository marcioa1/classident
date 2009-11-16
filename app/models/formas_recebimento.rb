class FormasRecebimento < ActiveRecord::Base
  has_many :recebimentos
  
  named_scope :por_nome ,:order=>:nome
end
