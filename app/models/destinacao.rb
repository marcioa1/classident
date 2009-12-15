class Destinacao < ActiveRecord::Base
  belongs_to :clinica
  has_many :cheques
end
