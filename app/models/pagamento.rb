class Pagamento < ActiveRecord::Base
  belongs_to :clinica
  belongs_to :tipo_pagamento
  has_many :cheques
  
  named_scope :no_dia, lambda{|dia|
       {:conditions=>["data_de_pagamento = ? ",dia]}}
  named_scope :por_data, :order=>:data_de_pagamento
  named_scope :entre_datas, lambda{|inicio,fim| 
       {:conditions=>["data_de_pagamento >= ? and data_de_pagamento <= ?", inicio,fim]}}
  named_scope :tipos, lambda{|tipos| 
            {:conditions=>["tipo_pagamento_id in (?)", tipos]}}
  named_scope :nao_excluidos, :conditions=>["data_de_exclusao IS NULL"]
  named_scope :da_clinica, lambda{|clinica_id| {:conditions=>["clinica_id = ?", clinica_id]}}
       
end
