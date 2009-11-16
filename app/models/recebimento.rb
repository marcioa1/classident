class Recebimento < ActiveRecord::Base
  belongs_to :paciente
  belongs_to :formas_recebimento
  belongs_to :clinica
  
  named_scope :por_data, :order=>:data
  named_scope :entre_datas, lambda{|inicio,fim| 
       {:conditions=>["data >= ? and data <= ?", inicio,fim]}}
  
end
