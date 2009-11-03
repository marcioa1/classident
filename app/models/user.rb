class User < ActiveRecord::Base
  acts_as_authentic
  
  belongs_to :tipo_usuario
  belongs_to :clinica
  
  named_scope :ativos, :conditions=>["ativo = 't'"]
  named_scope :por_nome, :order=>:nome
  named_scope :master  , 
              :joins => ["INNER JOIN tipo_usuarios ON tipo_usuarios.id = users.tipo_usuario_id"],
              :conditions=>["tipo_usuarios.nivel == 0"]
              
  def master
    tipo_usuario.nivel==0
  end

  def pode_incluir_user
    tipo_usuario.nivel < 2
  end
  
  def pode_incluir_tabela
    tipo_usuario.nivel < 2
  end

end
