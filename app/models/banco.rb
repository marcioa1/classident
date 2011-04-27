class Banco < ActiveRecord::Base
  acts_as_audited
  has_many :cheques
  
  validates_presence_of :numero, :message => "não pode ser vazio"
  validates_presence_of :nome,  :message => "não pode ser vazio"
  validates_uniqueness_of :numero, :on => :create, :message => ": já existe um banco com este número."
  validates_uniqueness_of :nome, :on => :create, :message => " : já existe um vanco com este nome."
  named_scope :por_nome, :order=>:nome
  
  def numero_formatado
    aux = self.numero.to_s
    while aux.size < 3
      aux = '0' + aux
    end
    aux
  end
end
