class User < ActiveRecord::Base
  acts_as_authentic
  
  belongs_to :tipo_usuario
end
