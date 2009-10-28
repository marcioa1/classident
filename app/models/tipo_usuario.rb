class TipoUsuario < ActiveRecord::Base
  has_many :users
end
