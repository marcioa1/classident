class Entrada < ActiveRecord::Base
  
  belongs_to :clinica
  
  named_scope :da_clinica, lambda{|clinica_id| {:conditions=>["clinica_id = ?", clinica_id]}}
  named_scope :do_mes, lambda{|data| {:conditions=>["data between ? and ? ", 
    data.strftime("%Y-%m-01"),data.strftime("%Y-%m-31")]}}
  named_scope :do_dia, lambda{|dia| {:conditions=>["data = ?",dia]}}
  named_scope :entre_datas, lambda{|data_inicial, data_final| {:conditions=>["data between ? and ? ", 
      data_inicial, data_final]}}
  named_scope :entrada, :conditions=>["valor > 0"]
  named_scope :remessa, :conditions=>["valor < 0"]
  named_scope :confirmado, :conditions=>['data_confirmacao_da_entrada IS NOT NULL']
  
  def confirmada?
    data_confirmacao_da_entrada.present?  
  end
  
end
