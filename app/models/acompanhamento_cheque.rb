class AcompanhamentoCheque < ActiveRecord::Base
  belongs_to :cheque
  belongs_to :user
end
