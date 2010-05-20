class Cheque < ActiveRecord::Base
  has_many   :recebimentos
  belongs_to :banco
  belongs_to :destinacao
  belongs_to :clinica 
  belongs_to :pagamento
  
  validates_presence_of :banco, :on => :create, :message => "Não pode ser vazio"
  validates_presence_of :numero, :on => :create, :message => "Não pode ser vazio"
  validates_presence_of :valor, :message => "can't be blank"
  validates_numericality_of :valor, :message => "is not a number"
  
  named_scope :por_bom_para, :order=>:bom_para
  named_scope :com_destinacao, :conditions=>["destinacao_id IS NOT NULL"]
  named_scope :da_clinica, lambda{|clinica_id| {:conditions=>["clinica_id=?",clinica_id]}}
  named_scope :devolvidos, lambda{|data_inicial, data_final| 
      {:conditions=>["data_Reapresentacao IS NULL and data_primeira_devolucao between ? and ?", data_inicial, data_final]}}
  named_scope :devolvido_duas_vezes, :conditions=>["data_segunda_devolucao IS NOT NULL"]
  named_scope :devolvido_duas_vezes_entre_datas, lambda{|data_inicial, data_final| {:conditions=>["data_segunda_devolucao between ? and ? ", data_inicial, data_final ]}}
  named_scope :disponiveis_na_clinica, :conditions=>["data_segunda_devolucao IS NULL and 
         data_spc IS NULL and data_solucao IS NULL and data_arquivo_morto IS NULL
         and data_entrega_administracao IS NULL and pagamento_id IS NULL
         and destinacao_id IS NULL"]
  named_scope :disponiveis_na_administracao, :conditions=>["data_segunda_devolucao IS NULL and 
                data_spc IS NULL and data_solucao IS NULL and data_arquivo_morto IS NULL
                and pagamento_id IS NULL
                and destinacao_id IS NULL"]
  named_scope :do_banco, lambda{|banco| {:conditions=>["banco_id=?", banco]}}
  named_scope :do_valor, lambda{|valor| {:conditions=>["valor=?", valor]}}
  
  named_scope :entre_datas, lambda{|data_inicial, data_final| 
      {:conditions=>["bom_para between ? and ?", data_inicial, data_final]}}
  named_scope :entregues_a_administracao, :conditions=>["data_entrega_administracao IS NOT NULL"]
  named_scope :na_administracao, :conditions=>["data_recebimento_na_administracao IS NOT NULL"]
  named_scope :nao_excluidos, :conditions=>["data_de_exclusao IS NULL"]
  named_scope :nao_reapresentados, :conditions=>["data_reapresentacao IS NULL"]
  named_scope :nao_recebidos, :conditions=>["data_recebimento_na_administracao IS NULL"]  
  named_scope :reapresentados, lambda{|data_inicial, data_final| 
      {:conditions=>["data_reapresentacao between ? and ?", data_inicial, data_final]}}
  named_scope :recebidos_na_administracao, lambda{|data_inicial, data_final| 
          {:conditions=>["data_recebimento_na_administracao between ? and ?", data_inicial, data_final]}}
  named_scope :por_valor, :order=>"valor desc"
  named_scope :menores_que, lambda{|valor| {:conditions=>["valor<?", valor]}}
  named_scope :sem_segunda_devolucao, :conditions=>["data_segunda_devolucao IS NULL"]
  named_scope :sem_solucao, :conditions=>['data_solucao IS NULL']
  named_scope :spc, lambda{|data_inicial, data_final| 
      {:conditions=>["data_spc between ? and ?", data_inicial, data_final]}}
  named_scope :usados_para_pagamento, :conditions=>["pagamento_id IS NOT NULL"]
  def status
    return "arquivo morto" unless !arquivo_morto?
    return "SPC" unless !spc?
    return "solucionado" unless !solucionado?
    return "devolvido duas vezes em " + data_segunda_devolucao.to_s_br unless !devolvido_duas_vezes? 
    return "reapresentado em " + data_reapresentacao.to_s_br unless !reapresentado?
    return "devolvido uma vez em " + data_primeira_devolucao.to_s_br unless !devolvido_uma_vez?
    return "usado pgto na adm" if usado_para_pagamento? and recebido_pela_@administracao
    return "usado pgto na clínica" if usado_para_pagamento? and !recebido_pela_@administracao
    return "com destinação" if com_destinacao?
    return "recebido pela adm" if recebido_pela_@administracao
    return "entregue à adm" if entregue_a_@administracao
    return "disponível" unless !sem_devolucao? 
  end
  
  def sem_devolucao?
    data_primeira_devolucao.nil?
  end
  
  def devolvido_uma_vez?
    !data_primeira_devolucao.nil?  
  end
  
  def reapresentado?
    !data_reapresentacao.nil?
  end
  
  def devolvido_duas_vezes?
    !data_segunda_devolucao.nil?
  end
  
  def solucionado?
    !data_solucao.nil?
  end
  
  def spc?
    !data_spc.nil?
  end
  
  def arquivo_morto?
    !data_arquivo_morto.nil?
  end
  
  def entregue_a_@administracao
    !data_entrega_administracao.nil?
  end
  
  def recebido_pela_@administracao
    !data_recebimento_na_administracao.nil?
  end
  
  def usado_para_pagamento?
    !pagamento_id.nil?
  end
  
  def com_destinacao?
    !destinacao_id.nil?
  end
    
  def limpo?
    return false if devolvido_duas_vezes? and !solucionado?
    return false if spc?
    return false if arquivo_morto?
    return false if devolvido_uma_vez? and !devolvido_duas_vezes?
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
    result = ''
    
    self.recebimentos.each do |rec|
      result += rec.paciente.nome + "," if rec.paciente
    end
    if result.size>1
      result = result[0..(result.size-2)]
    end
    return result
  end
  
  def observacao
    result = ''
    result += self.banco.nome + '/' if self.banco.present?
    result += self.agencia + '/' if self.agencia.present?
    result += self.conta_corrente + '/' if self.conta_corrente.present?
    result += self.numero if self.numero.present?
    result
  end
end
#TODO Discutir qual cheque é disponivel