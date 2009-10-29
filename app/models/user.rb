class User < ActiveRecord::Base
  acts_as_authentic
  
  belongs_to :tipo_usuario
  belongs_to :clinica
  
  named_scope :ativos, :conditions=>["ativo = 't'"]
  named_scope :por_nome, :order=>:nome
end
