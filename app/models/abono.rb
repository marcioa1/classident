class Abono < ActiveRecord::Base
  
  validates_length_of :obs, :maximum => 20, :message => "must be present"
  
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
end
