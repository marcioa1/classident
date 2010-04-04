class Recebimento < ActiveRecord::Base
  belongs_to :paciente
  belongs_to :formas_recebimento
  belongs_to :clinica
  belongs_to :cheque
  
  validates_presence_of :valor, :message => "Não pode ser em branco."
  
  named_scope :por_data, :order=>:data
  named_scope :entre_datas, lambda{|inicio,fim| 
       {:conditions=>["data >= ? and data <= ?", inicio,fim]}}
  named_scope :da_clinica, lambda{|clinica_id| {:conditions=>["clinica_id=?", clinica_id]}}
  named_scope :das_clinicas, lambda{|clinicas| 
       {:conditions=>["clinica_id in (?)", clinicas]}}
  named_scope :excluidos, :conditions=>["data_de_exclusao IS NOT NULL"]
  named_scope :nas_formas, lambda{|formas| 
       {:conditions=>["formas_recebimento_id in (?)", formas]}}
  named_scope :no_dia, lambda{|dia| 
       {:conditions=>["data = ?",dia]}} 
  named_scope :nao_excluidos, :conditions=>["data_de_exclusao IS NULL"]
     
  def em_cheque?
    forma = FormasRecebimento.find(formas_recebimento_id)
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
          debugger
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
  
end
