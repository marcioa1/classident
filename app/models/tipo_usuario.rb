  class TipoUsuario < ActiveRecord::Base
  acts_as_audited
  has_many :users

  named_scope :master, :conditions=>["nivel=0"]
  
  NIVEL_MASTER     = 0
  NIVEL_ADM        = 1
  NIVEL_SECRETARIA = 2
  NIVEL_ASSISTENTE = 3
end
