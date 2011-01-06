class User < ActiveRecord::Base
  acts_as_authentic
  # acts_as_audited
  #TODO permitir auditar este model. No momento está dando conflito com authlogic
  
  belongs_to :tipo_usuario
  has_and_belongs_to_many :clinicas
  belongs_to :alta
  
  validates_presence_of :nome, :on => :create, :message => "campo obrigatório."
  
  named_scope :ativos, :conditions=>["ativo = ?", true]
  named_scope :inativos, :conditions=>['ativo = ?', false]
  named_scope :por_nome, :order=>:nome
  named_scope :master  , 
              :joins => ["INNER JOIN tipo_usuarios ON tipo_usuarios.id = users.tipo_usuario_id"],
              :conditions=>["tipo_usuarios.nivel == 0"]
              
  def master?
    tipo_usuario.nivel==0
  end

  def pode_incluir_user
    tipo_usuario.nivel < 2
  end
  
  def pode_incluir_tabela
    tipo_usuario.nivel < 2
  end
  
  def acesso_com_senha?
    tipo_usuario.nivel == TipoUsuario::NIVEL_MASTER or tipo_usuario.nivel == TipoUsuario::NIVEL_SECRETARIA
  end
  
  def horario_de_trabalho?
    true
    wdia = Date.today.wday
    case wdia
      when 0: self.dia_da_semana_0 && Time.current.strftime('%H:%M') >= self.hora_de_inicio_0.strftime('%H:%M') && Time.current.strftime('%H:%M') <= self.hora_de_termino_0.strftime('%H:%M')
      when 1: self.dia_da_semana_1 && Time.current.strftime('%H:%M') >= self.hora_de_inicio_1.strftime('%H:%M') && Time.current.strftime('%H:%M') <= self.hora_de_termino_1.strftime('%H:%M')
      when 2: self.dia_da_semana_2 && Time.current.strftime('%H:%M') >= self.hora_de_inicio_2.strftime('%H:%M') && Time.current.strftime('%H:%M') <= self.hora_de_termino_2.strftime('%H:%M')
      when 3: self.dia_da_semana_3 && Time.current.strftime('%H:%M') >= self.hora_de_inicio_3.strftime('%H:%M') && Time.current.strftime('%H:%M') <= self.hora_de_termino_3.strftime('%H:%M')
      when 4: self.dia_da_semana_4 && Time.current.strftime('%H:%M') >= self.hora_de_inicio_4.strftime('%H:%M') && Time.current.strftime('%H:%M') <= self.hora_de_termino_4.strftime('%H:%M')
      when 5: self.dia_da_semana_5 && Time.current.strftime('%H:%M') >= self.hora_de_inicio_5.strftime('%H:%M') && Time.current.strftime('%H:%M') <= self.hora_de_termino_5.strftime('%H:%M')
      when 5: self.dia_da_semana_6 && Time.current.strftime('%H:%M') >= self.hora_de_inicio_6.strftime('%H:%M') && Time.current.strftime('%H:%M') <= self.hora_de_termino_6.strftime('%H:%M')
    end
  end

  def nome_das_clinicas
    result = ''
    self.clinicas.each do |cl|
      result += cl.nome + ','
    end
    result
  end
end
