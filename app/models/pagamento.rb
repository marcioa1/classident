class Pagamento < ActiveRecord::Base
  belongs_to :clinica
  belongs_to :tipo_pagamento
  
  named_scope :por_data, :order=>:data_de_pagamento
  named_scope :entre_datas, lambda{|inicio,fim| 
       {:conditions=>["data_de_pagamento >= ? and data_de_pagamento <= ?", inicio,fim]}}
end
