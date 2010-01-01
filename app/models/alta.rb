class Alta < ActiveRecord::Base
  belongs_to :paciente
  belongs_to :user
end
