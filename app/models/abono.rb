class Abono < ActiveRecord::Base
  
  belongs_to :paciente
  
  validates_length_of :observacao, :maximum => 20, :message => "Escreva a observação."
  validates_presence_of :data, :valor, :paciente_id
  
  named_scope :da_classident, :conditions => "clinica_id < 8"
  named_scope :entre_datas, lambda {|data_inicial, data_final| {:conditions => ["data between ? and ? ", data_inicial, data_final]}}
  
  attr_accessor :data_br, :valor_real
  
  
  
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
  
  def pode_alterar?(current_user)
    current_user.master?
  end
  
 
end
