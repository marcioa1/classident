class User < ActiveRecord::Base
  acts_as_authentic
  
  belongs_to :tipo_usuario
  belongs_to :clinica
  
  named_scope :ativos, :conditions=>["ativo = 't'"]
  named_scope :por_nome, :order=>:nome
  #TODO fazer abaixo com join em tipo_usuario
  #named_scope :master, :conditions=>[:tipo_usuario.nivel=>0]
  
  def pode_incluir_user
    tipo_usuario.nivel < 2
  end
  
  def pode_incluir_tabela
    tipo_usuario.nivel < 2
  end

end
