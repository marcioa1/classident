class Paciente < ActiveRecord::Base
  belongs_to :tabela
  has_many :tratamentos
  
  
  
end
