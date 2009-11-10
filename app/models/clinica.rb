class Clinica < ActiveRecord::Base
  has_many :users
  has_many :pagamentos
end
