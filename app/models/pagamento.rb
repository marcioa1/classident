class Pagamento < ActiveRecord::Base
  acts_as_audited
  belongs_to :clinica
  belongs_to :tipo_pagamento
  belongs_to :conta_bancaria
  has_many   :cheques
  has_many   :trabalho_proteticos
  belongs_to :protetico
  belongs_to :dentista
  has_many   :custos, :class_name => "Pagamento", :foreign_key => "pagamento_id"
  belongs_to :pagamento, :class_name => "Pagamento"
  
  validates_presence_of :data_de_pagamento, :message => " : obrigatória."
  validate :verifica_quinzena, :valor_tem_que_ser_positivo
  validates_numericality_of :valor_pago, :message => " : deve ser numérico"
  
  named_scope :ao_protetico, lambda{|protetico_id| {:conditions=>["protetico_id = ?", protetico_id]}}
  named_scope :aos_proteticos, :conditions => 'protetico_id IS NOT NULL'
  named_scope :com_cheque_da_classident, :conditions => "forma_de_pagamento = 'Cheque classident'"
  named_scope :com_cheque_de_paciente, :conditions => 'forma_de_pagamento = "Cheque paciente"'
  named_scope :da_clinica, lambda{|clinica_id| {:conditions=>["clinica_id = ?", clinica_id]}}
  named_scope :em_dinheiro, :conditions => 'forma_de_pagamento = "dinheiro"'
  named_scope :entre_datas, lambda{|inicio,fim| 
       {:conditions=>["data_de_pagamento between ? and ?", inicio,fim]}}
  named_scope :excluidos, :conditions=>["data_de_exclusao IS NOT NULL"]
  named_scope :filhos, lambda{|pagamento_id| {:conditions=>["pagamento_id = ?", pagamento_id]}}
  named_scope :fora_do_livro_caixa, :conditions=>['nao_lancar_no_livro_caixa = ? AND nao_lancar_no_livro_caixa IS NOT NULL', true]
  named_scope :no_dia, lambda{|dia|
       {:conditions=>["data_de_pagamento = ? ",dia]}}
  named_scope :no_livro_caixa, :conditions=>['nao_lancar_no_livro_caixa = ? OR nao_lancar_no_livro_caixa IS NULL', false]
  named_scope :tipos, lambda{|tipos| 
            {:conditions=>["tipo_pagamento_id in (?)", tipos]}}
  named_scope :nao_excluidos, :conditions=>["data_de_exclusao IS NULL"]
  named_scope :nao_sendo_transferencia, :conditions =>["observacao NOT LIKE ?  ", '%ransfer%']
  named_scope :pela_administracao, :conditions=>["pagamento_id IS NOT NULL"]
  named_scope :pela_conta_bancaria, lambda {|conta_bancaria_id| {:conditions=>["conta_bancaria_id = ? ", conta_bancaria_id]}}
  named_scope :por_data, :order=>:data_de_pagamento
#  named_scope :total,  :sum('valor_pago') #conditions=>['sum valor_pago where data between ? and ? ', '2009-01-01', '2009-01-31']
       
  attr_accessor :valor_restante_br, :valor_cheque_br
  
  def valor_restante_br()
    self.valor_restante.real
  end 
  def valor_restante_br=(valor)
    self.valor_restante = valor.gsub('.','').gsub(',', '.')
  end

  def valor_cheque_br()
    self.valor_cheque.real
  end 
  def valor_cheque_br=(valor)
    self.valor_cheque = valor.gsub('.','').gsub(',', '.')
  end
      
   OPCAO_RESTANTE_EM_DINHEIRO = 2
 
  include ApplicationHelper

  before_save :atribui_forma_de_pagamento
  
  def atribui_forma_de_pagamento
     self.forma_de_pagamento = self.modo_de_pagamento
  end
 
  attr_accessor :valor_pago_real, :data_de_pagamento_pt, :valor_dinheiro
  
  def valor_pago_real
    self.valor_pago.real.to_s
  end
  def valor_pago_real=(valor=0)
    self.valor_pago = valor.gsub('.', '').sub(',', '.')
  end

  def data_de_pagamento_pt
    data_de_pagamento_pt = data_de_pagamento.to_s_br if data_de_pagamento
  end
  def data_de_pagamento_pt=(nova_data)
    self.data_de_pagamento = nova_data.to_date if Date.valid?(nova_data)
  end
  
  def valor_dinheiro
    self.valor_terceiros = 0 if self.valor_terceiros.nil?
    self.valor_pago = 0 if self.valor_pago.nil?
    self.valor_cheque = 0 if self.valor_cheque.nil?
    self.valor_pago - self.valor_terceiros - self.valor_cheque
  end
  
  def verifica_quinzena
    errors.add(:data_de_pagamento, "não pode ser fora da quinzena.") if
      !self.na_quinzena? && self.em_dinheiro?# < Date.today  
  end
  
  def descricao_opcao_restante
    return "Sem valor restante" if opcao_restante==0  
    return "Pago em cheque" if opcao_restante ==1
    return "Pago em dinheiro" if opcao_restante ==2
    return "Fica devendo" if opcao_restante == 3
    return "Ignora" if opcao_restante == 4
    return "Recebe troco" if opcao_restante == 5
  end
  
  def pagamento_das_clinicas?
    !Pagamento.filhos(self.id).empty?
  end
  
  def verifica_fluxo_de_caixa
    return false if self.em_cheque_classident?
    if !self.nao_lancar_no_livro_caixa && self.data_de_pagamento && self.data_de_pagamento < FluxoDeCaixa.data_atual(self.clinica_id)
      FluxoDeCaixa.voltar_para_a_data(self.data_de_pagamento, self.clinica_id)
    end
  end
  
  def pode_alterar?
    na_quinzena? || self.liberado_para_alteracao?
  end
  
  def na_quinzena?
    if self.data_de_pagamento
      primeira = Date.new(Date.today.year,Date.today.month,1)
      segunda  = Date.new(Date.today.year,Date.today.month,16)
      return false if self.data_de_pagamento < primeira
      return false if self.data_de_pagamento < segunda && Date.today >= segunda
      return true if self.data_de_pagamento < segunda && Date.today < segunda
      return true if self.data_de_pagamento >= segunda && Date.today >= segunda
    else
      return false
    end
  end
  
  def em_dinheiro?
    !self.em_cheque_pacientes? && !self.em_cheque_classident?
  end
  
  def em_cheque_pacientes?
    self.valor_terceiros > 0 #!self.cheques.empty?
  end

  def em_cheque_classident?
    (self.conta_bancaria_id && self.conta_bancaria_id > 0 && self.cheques.empty?)
  end
  
  def modo_de_pagamento
    return "Cheque paciente" if em_cheque_pacientes?
    return "Cheque classident" if em_cheque_classident?
    return "Dinheiro" if em_dinheiro?
  end
  
  def liberado_para_alteracao?
    reg = Alteracoe.find_by_tabela_and_id_liberado("pagamentos", self.id)
    reg && reg.data_correcao.nil?
  end

   def valor_tem_que_ser_positivo
     errors.add(:valor, "não pode negativo") if
      !valor.blank? and valor < 0
  end

end
