class Pagamento < ActiveRecord::Base
  belongs_to :clinica
  belongs_to :tipo_pagamento
  has_many :cheques
  has_many :trabalho_proteticos
  belongs_to :protetico
  
  named_scope :ao_protetico, lambda{|protetico_id| {:conditions=>["protetico_id = ?", protetico_id]}}
  named_scope :no_dia, lambda{|dia|
       {:conditions=>["data_de_pagamento = ? ",dia]}}
  named_scope :por_data, :order=>:data_de_pagamento
  named_scope :entre_datas, lambda{|inicio,fim| 
       {:conditions=>["data_de_pagamento >= ? and data_de_pagamento <= ?", inicio,fim]}}
  named_scope :tipos, lambda{|tipos| 
            {:conditions=>["tipo_pagamento_id in (?)", tipos]}}
  named_scope :nao_excluidos, :conditions=>["data_de_exclusao IS NULL"]
  named_scope :da_clinica, lambda{|clinica_id| {:conditions=>["clinica_id = ?", clinica_id]}}
       
  def descricao_opcao_restante
    return "Sem valor restante" if opcao_restante==0  
    return "Pago em cheque" if opcao_restante ==1
    return "Pago em dinheiro" if opcao_restante ==2
    return "Fica devendo" if opcao_restante == 3
    return "Ignora" if opcao_restante == 4
    return "Recebe troco" if opcao_restante == 5
  end
  
end
