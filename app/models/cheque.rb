class Cheque < ActiveRecord::Base
  acts_as_audited
  has_many   :recebimentos
  belongs_to :banco
  belongs_to :destinacao
  belongs_to :clinica 
  belongs_to :pagamento
  has_many   :acompanhamento_cheques
  
  validates_presence_of :banco, :on => :create, :message => "Não pode ser vazio"
  validates_presence_of :numero, :on => :create, :message => "Não pode ser vazio"
  validates_presence_of :valor, :message => "Não pode ser vazio"
  validates_presence_of :bom_para,  :message => "Não pode ser vazio"
  validates_numericality_of :valor, :greater_then => 0, :message => "valor tem que ser maior que zero."
  # validate :bom_para_nao_pode_ser_15_dias_anterior
  validate :valor_tem_que_ser_positivo
  
  # validate :valor_igual_ao_recebimento
  
  named_scope :ate_a_data, lambda {|data| {:conditions => ['bom_para <= ?', data]}}
  named_scope :arquivo_morto, :conditions => ["data_arquivo_morto IS NOT NULL"]
  named_scope :arquivo_morto_entre_datas, lambda{|data_inicial, data_final| { :conditions => ["data_arquivo_morto BETWEEN ? AND ? ", data_inicial, data_final]}}
  named_scope :com_destinacao, :conditions=>["destinacao_id IS NOT NULL"]
  named_scope :com_numero, lambda{|numero| {:conditions=>["numero=?",numero ]}}
  named_scope :da_agencia, lambda{|agencia| {:conditions=>["agencia=?",agencia]}}
  named_scope :da_clinica, lambda{|clinica_id| {:conditions=>["clinica_id=?",clinica_id]}}
  named_scope :das_clinicas, lambda{|clinicas| {:conditions=>["clinica_id in (?) ", clinicas]}}
  named_scope :devolvidos, lambda{|data_inicial, data_final| 
      {:conditions=>["data_reapresentacao IS NULL and data_primeira_devolucao between ? and ?", data_inicial, data_final]}}
  named_scope :devolvidos_a_clinica, :conditions=>["data_envio_a_clinica IS NOT NULL"]
  named_scope :devolvidos_a_clinica_entre_datas, lambda {|data_inicial,data_final| {:conditions=>["data_envio_a_clinica between ? and ?", data_inicial, data_final] }} 
  named_scope :devolvido_duas_vezes, :conditions=>["data_segunda_devolucao IS NOT NULL"]
  named_scope :devolvido_duas_vezes_entre_datas, lambda{|data_inicial, data_final| {:conditions=>["data_segunda_devolucao between ? and ? ", data_inicial, data_final ]}}
  named_scope :disponiveis_na_clinica, :conditions=>["data_segunda_devolucao IS NULL and 
         data_spc IS NULL and data_solucao IS NULL and data_arquivo_morto IS NULL
         and data_entrega_administracao IS NULL and pagamento_id IS NULL
         and destinacao_id IS NULL"]
  named_scope :disponiveis_na_administracao, :conditions=>["data_segunda_devolucao IS NULL and 
                data_spc IS NULL and data_solucao IS NULL and data_arquivo_morto IS NULL and
                data_recebimento_na_administracao IS NOT NULL 
                and pagamento_id IS NULL
                and destinacao_id IS NULL and
                bom_para > '2011-01-01'"]
  named_scope :do_banco, lambda{|banco| {:conditions=>["banco_id = ?", banco]}}
  named_scope :do_valor, lambda{|valor| {:conditions=>["valor=?", valor]}}
  
  named_scope :entre_datas, lambda{|data_inicial, data_final| 
      {:conditions=>["bom_para between ? and ?", data_inicial, data_final]}}
  named_scope :entregues_a_administracao, :conditions=>["data_entrega_administracao IS NOT NULL"]
  named_scope :enviados_a_administracao, lambda{|inicio,fim| {:conditions=>["data_entrega_administracao IS NOT NULL and bom_para between ? and ? ", inicio, fim]}}
  named_scope :na_administracao, :conditions=>["data_recebimento_na_administracao IS NOT NULL"]
  named_scope :nao_excluidos, :conditions=>["data_de_exclusao IS NULL"]
  named_scope :nao_reapresentados, :conditions=>["data_reapresentacao IS NULL"]
  named_scope :nao_recebidos, :conditions=>["data_recebimento_na_administracao IS NULL"]  
  named_scope :reapresentados, lambda{|data_inicial, data_final| 
      {:conditions=>["data_reapresentacao between ? and ?", data_inicial, data_final]}}
  named_scope :recebidos_na_administracao, lambda{|data_inicial, data_final| 
          {:conditions=>["data_recebimento_na_administracao between ? and ?", data_inicial, data_final]}}
  named_scope :ordenado_por, lambda {|ordem| {:order => ordem.to_sym}}
  named_scope :por_bom_para, :order=>:bom_para
  named_scope :por_valor, :order=>'valor desc'
  named_scope :recebidos_pela_clinica_entre_datas, lambda {|data_inicial, data_final|
                {:conditions=>["data_recebido_da_administracao between ? and ? ", data_inicial, data_final]}}
  named_scope :menores_ou_igual_a, lambda{|valor| {:conditions=>["valor<=?", valor]}}
  named_scope :menores_que, lambda{|valor| {:conditions=>["valor<?", valor]}}
  named_scope :sem_segunda_devolucao, :conditions=>["data_segunda_devolucao IS NULL"]
  named_scope :sem_solucao, :conditions=>['data_solucao IS NULL']
  named_scope :solucionado, :conditions=>['data_solucao IS NOT NULL']
  named_scope :solucionado_entre_datas, lambda{|data_inicial, data_final| 
      {:conditions=>['data_solucao BETWEEN ? AND ? ' ,data_inicial, data_final]}}
  named_scope :spc, lambda{|data_inicial, data_final| 
      {:conditions=>["data_spc between ? and ?", data_inicial, data_final]}}
  named_scope :usados_para_pagamento, :conditions=>["pagamento_id IS NOT NULL"]
  named_scope :vindo_da_clinica, lambda{|clinicas| {:conditions=>["clinica_id in (?)", clinicas]}}
  
  attr_accessor :valor_real, :bom_para_br, :data_segunda_devolucao_br, 
                :data_spc_br, :data_solucao_br, :data_arquivo_morto_br
  
  def bom_para_br
    self.bom_para.to_s_br
  end
  def bom_para_br=(valor)
    self.bom_para = valor.to_date if Date.valid?(valor)  
  end
  
  def data_segunda_devolucao_br
    self.data_segunda_devolucao.to_s_br
  end
  def data_segunda_devolucao_br=(valor)
    self.data_segunda_devolucao = valor.to_date if Date.valid?(valor)
  end
  
  def data_spc_br
    self.data_spc.to_s_br
  end
  def data_spc_br=(valor)
    self.data_spc = valor.to_date if Date.valid?(valor)  
  end
  
  def valor_real
    self.valor.real
  end
  def valor_real=(valor)
    self.valor = valor.gsub(".", "").sub(",",".")
  end
  
  def data_solucao_br
    self.data_solucao.to_s_br
  end
  def data_solucao_br=(valor)
    self.data_solucao = valor.to_date if Date.valid?(valor)  
  end
  
  def data_arquivo_morto_br
    self.data_arquivo_morto.to_s_br
  end
  def data_arquivo_morto_br=(valor)
    self.data_arquivo_morto = valor.to_date if Date.valid?(valor)  
  end

  def valor_igual_ao_recebimento
    total_recebimento = 0
    self.recebimentos.each do |rec|
      total_recebimento += rec.valor
    end
    if self.valor != total_recebimento
      self.errors.add(:valor, "O total dos valores do(s) recebimento(s) é diferente do valor deste cheque.")
    end
  end
  
  
  def status
    return "solucionado" unless !solucionado?
    return "arquivo morto" unless !arquivo_morto?
    return "SPC" unless !spc?
    return "devolvido duas vezes em " + data_segunda_devolucao.to_s_br unless !devolvido_duas_vezes? 
    return "reapresentado em " + data_reapresentacao.to_s_br unless !reapresentado?
    return "devolvido uma vez em " + data_primeira_devolucao.to_s_br unless !devolvido_uma_vez?
    return "usado pgto na adm" if usado_para_pagamento? and recebido_pela_administracao?
    return "usado pgto na clínica" if usado_para_pagamento? and !recebido_pela_administracao?
    return "com destinação" if com_destinacao?
    return "recebido pela adm" if recebido_pela_administracao?
    return "entregue à adm" if entregue_a_administracao?
    return "disponível" unless !sem_devolucao? 
  end
  
  def status_resumido
    return "arq morto" unless !arquivo_morto?
    return "solucionado" unless !solucionado?
    return "SPC" unless !spc?
    return "devol 2X:" + data_segunda_devolucao.to_s_br unless !devolvido_duas_vezes? 
    return "reapr. :" + data_reapresentacao.to_s_br unless !reapresentado?
    return "devolv.: " + data_primeira_devolucao.to_s_br unless !devolvido_uma_vez?
    return "pgto adm" if usado_para_pagamento? and recebido_pela_administracao?
    return "pgto clí" if usado_para_pagamento? and !recebido_pela_administracao?
    return "destinação" if com_destinacao?
    return "receb. adm" if recebido_pela_administracao?
    return "enviado adm" if entregue_a_administracao?
    return "devolvido à clínica" if devolvido_a_clinica?
    return "disponível" unless !sem_devolucao? 
  end
  
  def status_class
    return "arq_morto" unless !arquivo_morto?
    return "SPC" unless !spc?
    return "devol_2X" unless !devolvido_duas_vezes? 
    return "reapresentado" unless !reapresentado?
    return "devolvido"  unless !devolvido_uma_vez?
    return "pgto_adm" if usado_para_pagamento? and recebido_pela_administracao?
    return "pgto_cli" if usado_para_pagamento? and !recebido_pela_administracao?
    return "destinação" if com_destinacao?
    return "receb_adm" if recebido_pela_administracao?
    return "enviado_adm" if entregue_a_administracao?
    return "disponível" unless !sem_devolucao? 
    return "solucionado" unless !solucionado?
 end
  
  def nome_do_destino
    case 
      when self.status=~/usado pgto/ then 
        self.pagamento.tipo_pagamento.nome
      when self.status=~/destinação/ then
         self.destinacao.nome
      else self.status_resumido
    end
  end
  
  def sem_devolucao?
    data_primeira_devolucao.nil?
  end
  
  # estinacao?
  #     destinacao_id.present?    
  #   end
  
  def com_problema?
    !self.limpo?
  end
  
  def devolvido_uma_vez?
    data_primeira_devolucao.present?  || motivo_primeira_devolucao.present?
  end
  
  def reapresentado?
    data_reapresentacao.present?
  end
  
  def devolvido_duas_vezes?
    data_segunda_devolucao.present?
  end
  
  def solucionado?
    data_solucao.present?
  end
  
  def spc?
    data_spc.present?
  end
  
  def arquivo_morto?
    data_arquivo_morto.present?
  end
  
  def entregue_a_administracao?
    data_entrega_administracao.present? and !recebido_pela_administracao?
  end
  
  def recebido_pela_administracao?
    data_recebimento_na_administracao.present?
  end
  
  def usado_para_pagamento?
    pagamento_id.present?
  end
  
  def com_destinacao?
    destinacao_id.present?
  end
  
  def devolvido_a_clinica?
    self.data_envio_a_clinica.present?
  end
  
  def recebido_pela_clinica?
    self.data_recebido_da_administracao.present?
  end
    
  def limpo?
    return true if solucionado?
    return false if devolvido_duas_vezes? and !solucionado?
    return false if spc?
    return false if arquivo_morto?
    return false if devolvido_uma_vez? and reapresentado? and devolvido_duas_vezes?
    return false if devolvido_uma_vez? and !reapresentado?
    return true
  end
  
  def disponivel?
    return false if devolvido_duas_vezes?
    return false if spc?
    return false if arquivo_morto?
    return false if solucionado?
    return false if usado_para_pagamento?
    true
  end
  
  def nome_dos_pacientes
    result = []
    recebimentos = Recebimento.all(:conditions=>['cheque_id = ?',self.id])
    recebimentos.each do |rec|
      result << rec.paciente.nome if rec.paciente.present?
    end
    return result.join(',')
  end

  def nome_dos_outros_pacientes(recebimento_id)
    result = []
    recebimentos = Recebimento.all(:conditions=>['cheque_id = ? and id <> ?',self.id, recebimento_id])
    recebimentos.each do |rec|
      result << rec.paciente.nome  if rec.paciente.present?
    end
    return result.join(", ")
  end
  
  def observacao
    result = ''
    result += 'bc.' + self.banco.nome + '/' if self.banco.present?
    result += 'ag.' + self.agencia + '/' if self.agencia.present?
    result += 'num.'+ self.numero if self.numero.present?
    result
  end
  
  def para_mais_de_um_paciente?
    self.recebimentos.size > 1
  end
  
  def excluido?
    self.data_de_exclusao.present?
  end
  
  def acompanhamentos
    result = ''
    self.acompanhamento_cheques.each do |a|
      result += a.updated_at.to_s_br + " ( #{a.user && a.user.login} ) , " + a.descricao + "</br>"
    end
    result
  end
  
  def nome_dos_outros_pacientes(nome_paciente)
    nome = ""
    self.recebimentos.each do |rec|
      nome += rec.paciente.nome + " , " if rec.paciente.nome != nome_paciente
    end
    nome
  end
  
  def historico
    historia = ""
    historia = "devolvido em #{data_primeira_devolucao.to_s_br} motivo #{motivo_primeira_devolucao} \n" if devolvido_uma_vez?
    historia += "reapresentado em #{data_reapresentacao.to_s_br} \n" if reapresentado?
    historia += "devolvido pela segunda vez em #{data_segunda_devolucao.to_s_br} por #{motivo_segunda_devolucao} \n" if devolvido_duas_vezes?
    historia += "solucionado em #{data_solucao.to_s_br} , #{descricao_solucao}\n" if solucionado?
    self.acompanhamento_cheques.each do |acom|
      historia += acom.descricao + " ( #{acom.created_at.to_s_br}), "
    end
    historia
  end
  
  def envia_cheque_a_administracao(clinica_id, current_user)
    self.update_attributes(:data_entrega_administracao => Date.today,
                    :data_recebimento_na_administracao => nil)
    AcompanhamentoCheque.create(:cheque_id => self.id,
         :origem    => clinica_id,
         :user_id   => current_user.id, 
         :descricao => "#{current_user.nome} enviou o cheque à administração em #{Date.today}")
  end
  
  def confirma_recebimento_na_administracao(clinica_id, current_user)    
    self.update_attribute(:data_recebimento_na_administracao, Date.today)
    AcompanhamentoCheque.create(:cheque_id => self.id,
         :origem    => clinica_id,
         :user_id   => current_user.id, 
         :descricao => "#{current_user.nome} confirmou o recebimento em #{Date.today}")
  end
  
  def devolve_a_clinica(clinica_id, current_user)
    self.update_attribute(:data_envio_a_clinica, Date.today)
    AcompanhamentoCheque.create(:cheque_id => self.id,
         :origem    => clinica_id,
         :user_id   => current_user.id, 
         :descricao => "#{current_user.nome} devolveu à clínica em #{Date.today}")
  end
  
  def recebe_da_administracao(clinica_id, current_user)
    self.update_attribute(:data_recebido_da_administracao, Date.today)
    AcompanhamentoCheque.create(:cheque_id => self.id,
         :origem    => clinica_id,
         :user_id   => current_user.id, 
         :descricao => "#{current_user.nome} recebeu da administração em #{Date.today}")
  end

  def registra_destinacao(clinica_id, current_user, destinacao_id)
    self.update_attribute(:destinacao_id, destinacao_id)
    AcompanhamentoCheque.create(:cheque_id => self.id,
         :origem    => clinica_id,
         :user_id   => current_user.id, 
         :descricao => "#{current_user.nome} destinou o cheque em #{Date.today}")
  end

  def registra_disponivel(clinica_id, current_user)
    pagamento_id = self.pagamento_id
    self.update_attribute(:pagamento_id, nil)
    AcompanhamentoCheque.create(:cheque_id => self.id,
         :origem    => clinica_id,
         :user_id   => current_user.id, 
         :descricao => "#{current_user.nome} tornou este cheque disponível em #{Date.today} : ( id do pagamento anterior : #{pagamento_id})")
  end

  def pode_alterar?(user)
    return true if user.master?
    return false if user.secretaria? && self.recebido_pela_administracao?
    return false if self.usado_para_pagamento? || self.com_destinacao?
    true
  end
 
  private

  def bom_para_nao_pode_ser_15_dias_anterior
     errors.add(:bom_para, "não pode ser anterior a 15 dias") if
      !bom_para.blank? and bom_para < (Date.today - 15.days)
  end

  def valor_tem_que_ser_positivo
     errors.add(:valor, "não pode negativo") if
      !valor.blank? and valor < 0
  end
end
