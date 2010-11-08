class Pagamento < ActiveRecord::Base
  acts_as_audited
  belongs_to :clinica
  belongs_to :tipo_pagamento
  has_many   :cheques
  has_many   :trabalho_proteticos
  belongs_to :protetico
  belongs_to :dentista
  has_many   :custos, :class_name => "Pagamento", :foreign_key => "pagamento_id"
  belongs_to :pagamento, :class_name => "Pagamento"
  
  validates_presence_of :data_de_pagamento, :message => " : obrigatória."
  # validate :verifica_quinzena
  #FIXME Retirar na conversão
  validates_numericality_of :valor_pago, :message => " : deve ser numérico"
  
  named_scope :ao_protetico, lambda{|protetico_id| {:conditions=>["protetico_id = ?", protetico_id]}}
  named_scope :aos_proteticos, :conditions => 'protetico_id IS NOT NULL'
  named_scope :da_clinica, lambda{|clinica_id| {:conditions=>["clinica_id = ?", clinica_id]}}
  named_scope :entre_datas, lambda{|inicio,fim| 
       {:conditions=>["data_de_pagamento between ? and ?", inicio,fim]}}
  named_scope :filhos, lambda{|pagamento_id| {:conditions=>["pagamento_id = ?", pagamento_id]}}
  named_scope :fora_do_livro_caixa, :conditions=>['nao_lancar_no_livro_caixa = ?', true]
  named_scope :no_dia, lambda{|dia|
       {:conditions=>["data_de_pagamento = ? ",dia]}}
  named_scope :no_livro_caixa, :conditions=>['nao_lancar_no_livro_caixa = ?', false]
  named_scope :tipos, lambda{|tipos| 
            {:conditions=>["tipo_pagamento_id in (?)", tipos]}}
  named_scope :nao_excluidos, :conditions=>["data_de_exclusao IS NULL"]
  named_scope :pela_administracao, :conditions=>["pagamento_id IS NOT NULL"]
  named_scope :por_data, :order=>:data_de_pagamento
#  named_scope :total,  :sum('valor_pago') #conditions=>['sum valor_pago where data between ? and ? ', '2009-01-01', '2009-01-31']
       
   OPCAO_RESTANTE_EM_DINHEIRO = 2
 
  include ApplicationHelper

  attr_accessor :valor_pago_real, :data_de_pagamento_pt
  
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
  
  def verifica_quinzena
    errors.add(:data_de_pagamento, "não pode ser fora da quinzena.") if
      !na_quinzena?(data_de_pagamento)# < Date.today  
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
    if !self.nao_lancar_no_livro_caixa && self.data_de_pagamento && self.data_de_pagamento < FluxoDeCaixa.data_atual(self.clinica_id)
      FluxoDeCaixa.voltar_para_a_data(self.data_de_pagamento, self.clinica_id)
    end
  end
  
  def pode_alterar?
    na_quinzena?(self.data_de_pagamento)
  end
  
  def em_dinheiro?
    self.cheques.empty? && !self.em_cheque_classident?
  end
  
  def em_cheque_pacientes?
    !self.cheques.empty?
  end

  def em_cheque_classident?
    (self.conta_bancaria_id > 0)
  end
  
  def modo_de_pagamento
    return "Cheque classident" if em_cheque_classident?
    return "Cheque paciente" if em_cheque_pacientes?
    return "Dinheiro" if em_dinheiro?
  end
  
end
