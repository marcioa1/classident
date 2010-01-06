class Alta < ActiveRecord::Base
  belongs_to :paciente
  belongs_to :user
  belongs_to :user_termino, :class_name => "User", :foreign_key => "user_termino_id"
  
end
