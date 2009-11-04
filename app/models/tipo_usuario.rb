class TipoUsuario < ActiveRecord::Base
  has_many :users

  named_scope :master, :conditions=>["nivel==0"]
end
