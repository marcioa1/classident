class Recebimento < ActiveRecord::Base
  belongs_to :paciente
  belongs_to :formas_recebimento
  belongs_to :clinica
  has_one :cheque
  accepts_nested_attributes_for :cheque, :allow_destroy => true
  
  
  named_scope :por_data, :order=>:data
  named_scope :entre_datas, lambda{|inicio,fim| 
       {:conditions=>["data >= ? and data <= ?", inicio,fim]}}
  named_scope :formas, lambda{|formas| 
       {:conditions=>["formas_recebimento_id in (?)", formas]}}
  named_scope :da_clinica, lambda{|clinica_id| {:conditions=>["clinica_id=?", clinica_id]}}
  
  def em_cheque?
    forma = FormasRecebimento.find(formas_recebimento_id)
    if forma.nil?
      return false
    else
      return forma.nome.downcase=="cheque"
    end
  end
end
