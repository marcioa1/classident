class ContaBancaria < ActiveRecord::Base
  acts_as_audited
  belongs_to :clinica
  
  validates_presence_of :nome, :on =>:create, :message => "não pode ser vazio."
  
end
