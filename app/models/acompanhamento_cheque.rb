class AcompanhamentoCheque < ActiveRecord::Base
  
  belongs_to :cheque
  belongs_to :user
  
  validates_presence_of :descricao
  validates_length_of :descricao, :within => 1..250

end
