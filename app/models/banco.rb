class Banco < ActiveRecord::Base
  has_many :cheques
  
  validates_presence_of :numero, :message => "não pode ser vazio"
  validates_presence_of :nome,  :message => "não pode ser vazio"
  validates_uniqueness_of :numero, :on => :create, :message => ": já existe um banco com este número."
  validates_uniqueness_of :nome, :on => :create, :message => " : já existe um vanco com este nome."
  named_scope :por_nome, :order=>:nome
end
