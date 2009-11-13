class Clinica < ActiveRecord::Base
  has_many :users
  has_many :pagamentos
  has_and_belongs_to_many :dentistas
  #TODO um dentista em mais de uma clínica
end
