class Indicacao < ActiveRecord::Base
  acts_as_audited
  has_many :pacientes
  
  named_scope :por_descricao, :order=>:descricao
end
