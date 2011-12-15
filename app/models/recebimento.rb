class Recebimento < ActiveRecord::Base
  acts_as_audited
  belongs_to :paciente
  belongs_to :formas_recebimento
  belongs_to :clinica
  belongs_to :cheque
   
  usar_como_dinheiro :valor
  FORMATO_VALIDO_BR  	=  	/^([R|r]\$\s*)?(([+-]?\d{1,3}(\.?\d{3})*))?(\,\d{0,2})?$/
  
  
  named_scope :por_data, :order=>:data
  named_scope :entre_datas, lambda{|inicio,fim| 
       {:conditions=>["recebimentos.data >= ? and recebimentos.data <= ?", inicio,fim]}}
  named_scope :da_clinica, lambda{|clinica_id| {:conditions=>["clinica_id=?", clinica_id]}}
  named_scope :das_clinicas, lambda{|clinicas| 
       {:conditions=>["clinica_id in (?)", clinicas]}}
  named_scope :em_cheque, :conditions=>['cheque_id IS NOT NULL']
  named_scope :excluidos, :conditions=>["data_de_exclusao IS NOT NULL"]
  named_scope :nas_formas, lambda{|formas| 
       {:conditions=>["formas_recebimento_id in (?)", formas]}}
  named_scope :no_dia, lambda{|dia| 
       {:conditions=>["data = ?",dia]}} 
  named_scope :nao_excluidos, :conditions=>["data_de_exclusao IS NULL"]
     
  named_scope :com_problema, :include=>:cheque, :conditions => ['cheques.data_reapresentacao IS NULL and cheques.data_primeira_devolucao IS NOT NULL']

  attr_accessor :valor_real, :data_pt_br
  #, :valor_segundo_paciente, :valor_terceiro_paciente, :valor_do_cheque
  
  
  validates_presence_of :valor, :message => "Não pode ser em branco."
  validates_numericality_of :valor, :greater_than => 0, :message => " tem que ser numérico maior que zero."
  validates_numericality_of :percentual_dentista, :message => "deve ser um número."
  validates_presence_of :observacao_exclusao, :if => :excluido?
  validate :verifica_quinzena, :verifica_data_do_cheque, 
           :valor_tem_que_ser_positivo, :dinheiro_somente_hoje
  # validates_numericality_of :valor_segundo_paciente, :only => [:create, :update] , :message => "não é numérico"
  #   validates_numericality_of :valor_terceiro_paciente, :only => [:create, :update] , :message => "não é numérico"
  #   validates_numericality_of :valor_do_cheque, :only => [:create, :update] , :message => "não é numérico"
  
  def na_quinzena?
    primeira = Date.new(Date.today.year,Date.today.month,1)
    segunda  = Date.new(Date.today.year,Date.today.month,16)
    if Date.today >= segunda
      self.data < segunda ? false : true
    else
      self.data < primeira ? false : true
    end
    
    # return false if self.data < segunda && Date.today >= segunda
    # return true if self.data < segunda && Date.today < segunda
    # return true if self.data >= segunda && Date.today >= segunda
    # return true

  end
  
  def verifica_quinzena
    errors.add(:data, "Fora da quinzena : anterior ao dia #{@data_inicial.to_s_br}") if !self.pode_alterar?
  end
  
  def verifica_data_do_cheque
    errors.add(:data, " data do cheque não pode ser vazia") if self.em_cheque? && self.cheque && self.cheque.bom_para.nil?
    errors.add(:data, " do cheque anterior à data do recebimento") if self.em_cheque? && self.cheque.bom_para && self.cheque.bom_para < self.data
  end
  
  def valor_real
    self.valor.real
  end
  def valor_real=(valor)
    self.valor = valor.gsub('.','').gsub(',', '.')
  end
  
  def data_pt_br
    self.data = Date.today if self.data.nil?
    self.data.to_s_br
  end
  
  def data_pt_br=(data)
    self.data = data.to_date if Date.valid?(data)
  end
  
  def valor_do_cheque
    if self.em_cheque?
      valor_do_cheque = self.cheque.valor.real
    else
      valor_do_cheque = '0,00'
    end
  end
  
  def observacao_recebimento
    if self.observacao.blank? && self.em_cheque?
      return self.cheque.nil? ? '' : self.cheque.observacao
    else
      return self.observacao
    end
  end

  def em_cheque?
    return false if self.formas_recebimento_id.nil?
    forma = FormasRecebimento.find(self.formas_recebimento_id)
    return false if forma.nil?
    forma.nome.downcase=="cheque" ? true : false
  end
  
  def em_dinheiro?
    return false if self.formas_recebimento_id.nil?
    forma = FormasRecebimento.find(self.formas_recebimento_id)
    return false if forma.nil?
    forma.nome.downcase=="dinheiro" ? false : true
  end  
  
  def em_cartao?
    !self.em_dinheiro? && !self.em_cheque?
  end
  
  def excluido?
    data_de_exclusao.present?
  end
  
  def pode_alterar?
    self.na_quinzena? || self.liberado_para_alteracao?
  end
  
  def pode_excluir?
    self.na_quinzena? || self.liberado_para_alteracao?
  end
  
  def liberado_para_alteracao?
    reg = Alteracoe.find_by_tabela_and_id_liberado(self.class.table_name, self.id)
    reg && reg.data_correcao.nil?
  end
  
  def observacao_do_recebimento
    observacao = self.observacao.nil? ? '' : self.observacao
    observacao += ' - ' + self.cheque.observacao if self.em_cheque? && self.cheque.present?
    return observacao
  end
  
  def exclui(user, obs)
    if self.cheque
      self.cheque.update_attribute(:data_de_exclusao, Time.current)
      todos = self.cheque.recebimentos
    else
      todos = self.to_a
    end
    todos.each do |rec|
      rec.update_attributes(:data_de_exclusao    => Time.current, 
                            :observacao_exclusao => obs, 
                            :usuario_exclusao    => user)
    end
  end
    
  def verifica_fluxo_de_caixa
    if self.data < FluxoDeCaixa.data_atual(self.clinica_id)
      FluxoDeCaixa.voltar_para_a_data(self.data, self.clinica_id)
    end
  end
  
  def valor_do_ortodontista
    if self.percentual_dentista
      self.valor * self.percentual_dentista / 100
    else
      0
    end
  end
  
  def method_missing(symbol, *params)
     if (symbol.to_s =~ /^(.*)_before_type_cast$/)
       send $1
     else
       super
     end
   end
   
   def valor_tem_que_ser_positivo
     errors.add(:valor, "não pode negativo") if
      !valor.blank? and valor < 0
  end

  def dinheiro_somente_hoje
     errors.add(:data, "não pode no futuro se o recebimento não for em cheque") if
      !self.em_cheque? and self.data > Date.today
  end
  
  # private
  # para impressão detalhada
  def descricao
    self.observacao
  end
  
  def custo
    0
  end
  def valor_dentista
    self.valor * self.percentual_dentista
  end
end
