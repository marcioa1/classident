class Clinica < ActiveRecord::Base
  has_many :users
  has_many :pagamentos
  has_and_belongs_to_many :dentistas
  has_many :recebimentos
  has_many :cheques
  
end
