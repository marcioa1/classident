class Entrada < ActiveRecord::Base
  
  named_scope :da_clinica, lambda{|clinica_id| {:conditions=>["clinica_id = ?", clinica_id]}}
  named_scope :do_mes, lambda{|data| {:conditions=>["data between ? and ? ", 
    data.year.to_s + "-" + data.month.to_s + "-01",data.year.to_s + "-" + data.month.to_s + "-31"]}}
end
