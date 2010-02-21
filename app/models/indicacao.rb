class Indicacao < ActiveRecord::Base
  has_many :pacientes
  
  named_scope :por_descricao, :order=>:descricao
end
