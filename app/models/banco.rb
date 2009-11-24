class Banco < ActiveRecord::Base
  has_many :cheques
end
