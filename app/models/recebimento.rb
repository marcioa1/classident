class Recebimento < ActiveRecord::Base
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
  # validates_numericality_of :valor_segundo_paciente, :only => [:create, :update] , :message => "não é numérico"
  #   validates_numericality_of :valor_terceiro_paciente, :only => [:create, :update] , :message => "não é numérico"
  #   validates_numericality_of :valor_do_cheque, :only => [:create, :update] , :message => "não é numérico"
  
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

  def em_cheque?
    return false if self.formas_recebimento_id.nil?
    forma = FormasRecebimento.find(self.formas_recebimento_id)
    if forma.nil?
      return false
    else
      return forma.nome.downcase=="cheque"
    end
  end
  
  def excluido?
    !data_de_exclusao.nil?
  end
  
  def observacao_do_recebimento
    if self.observacao.nil? 
      if self.em_cheque?
        if self.cheque.present? 
          return self.cheque.observacao
        else
          return '.'
        end
      else 
        return '-'
      end
    else
      if self.em_cheque?
        if self.cheque.nil?
          return self.observacao
        else
          return self.observacao + " - " + self.cheque.observacao 
        end
      else
        return self.observacao
      end
    end
  end
    
# def cheque
#    cheque = Cheque.find_by_recebimento_id(id)
#  end
  def method_missing(symbol, *params)
     if (symbol.to_s =~ /^(.*)_before_type_cast$/)
       send $1
     else
       super
     end
   end
end
