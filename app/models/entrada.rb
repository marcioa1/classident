class Entrada < ActiveRecord::Base
  
  named_scope :da_clinica, lambda{|clinica_id| {:conditions=>["clinica_id = ?", clinica_id]}}
  named_scope :do_mes, lambda{|data| {:conditions=>["data between ? and ? ", 
    data.strftime("%Y-%m-01"),data.strftime("%Y-%m-31")]}}
  named_scope :entrada, :conditions=>["valor > 0"]
  named_scope :remessa, :conditions=>["valor < 0"]
end
