class User < ActiveRecord::Base
  acts_as_authentic
  # acts_as_audited
  #TODO permitir auditar este model. No momento está dando conflito com authlogic
  
  belongs_to :tipo_usuario
  has_and_belongs_to_many :clinicas
  belongs_to :alta
  has_many   :acompanhamento_cheques
  
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
  
  def administradora?
    tipo_usuario.nivel==1
  end

  def secretaria?
    tipo_usuario.nivel==2
  end
  
  def dentista?
    tipo_usuario.nivel==4
  end

  def pode_incluir_user
    tipo_usuario.nivel < 2
  end
  
  def pode_incluir_tabela
    self.master?
  end
  
  def acesso_com_senha?
    tipo_usuario.nivel == TipoUsuario::NIVEL_MASTER or tipo_usuario.nivel == TipoUsuario::NIVEL_SECRETARIA
  end
  
  def horario_de_trabalho?
    wdia = Date.today.wday
    hora_corrente = Time.current.strftime('%H%M').to_i
    case wdia
      when 0: self.dia_da_semana_0 && hora_corrente >= self.hora_de_inicio_0.strftime('%H%M').to_i && hora_corrente <= self.hora_de_termino_0.strftime('%H%M').to_i
      when 1: self.dia_da_semana_1 && hora_corrente >= self.hora_de_inicio_1.strftime('%H%M').to_i && hora_corrente <= self.hora_de_termino_1.strftime('%H%M').to_i
      when 2: self.dia_da_semana_2 && hora_corrente >= self.hora_de_inicio_2.strftime('%H%M').to_i && hora_corrente <= self.hora_de_termino_2.strftime('%H%M').to_i
      when 3: self.dia_da_semana_3 && hora_corrente >= self.hora_de_inicio_3.strftime('%H%M').to_i && hora_corrente <= self.hora_de_termino_3.strftime('%H%M').to_i
      when 4: self.dia_da_semana_4 && hora_corrente >= self.hora_de_inicio_4.strftime('%H%M').to_i && hora_corrente <= self.hora_de_termino_4.strftime('%H%M').to_i
      when 5: self.dia_da_semana_5 && hora_corrente >= self.hora_de_inicio_5.strftime('%H%M').to_i && hora_corrente <= self.hora_de_termino_5.strftime('%H%M').to_i
      when 6: self.dia_da_semana_6 && hora_corrente >= self.hora_de_inicio_6.strftime('%H%M').to_i && hora_corrente <= self.hora_de_termino_6.strftime('%H%M').to_i
    end
  end

  def nome_das_clinicas
    result = ''
    self.clinicas.each do |cl|
      result += cl.nome + ','
    end
    result
  end
  
  def pode_alterar_na_clinica?
    self.secretaria? || self.master?
  end
end
