class AcompanhamentoCheque < ActiveRecord::Base
  belongs_to :cheque
  belongs_to :user
  belongs_to :cheque
  
  validates_presence_of :descricao
  validates_length_of :descricao, :within => 1..120
end
