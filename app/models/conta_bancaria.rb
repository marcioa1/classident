class ContaBancaria < ActiveRecord::Base
  
  belongs_to :clinica
  
  validates_presence_of :nome, :on =>:create, :message => "não pode ser vazio."
  
end
