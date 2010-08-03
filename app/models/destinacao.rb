class Destinacao < ActiveRecord::Base
  acts_as_audited
  belongs_to :clinica
  has_many :cheques
end
