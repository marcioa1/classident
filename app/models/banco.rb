class Banco < ActiveRecord::Base
  has_many :cheques
  
  validates_presence_of :numero, :message => "não pode ser vazio"
  validates_presence_of :nome,  :message => "não pode ser vazio"
  named_scope :por_nome, :order=>:nome
end
