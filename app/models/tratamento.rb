class Tratamento < ActiveRecord::Base
  belongs_to :paciente
  belongs_to :item_tabela
  belongs_to :dentista
  belongs_to :clinica
  
  named_scope :do_paciente, lambda{|paciente_id| {:conditions=>["paciente_id = ? and excluido=?", paciente_id,false]}}
  named_scope :do_dentista, lambda{|dentista_id| {:conditions=>["dentista_id = ? ", dentista_id]}}
  named_scope :nao_excluido, :conditions=>["excluido = ?",false]
  named_scope :por_data, :order=>:data
  named_scope :entre, lambda{|inicio,fim| {:conditions=>["data>=? and data <=?", inicio,fim]}}
  named_scope :da_clinica, lambda{|clinicas| {:conditions=>["clinica_id in (?)",clinicas]}}
  
  def valor_dentista
    valor * dentista.percentual / 100 
  end
  
  def valor_clinica
    valor * (100 - dentista.percentual) / 100 
  end
end
