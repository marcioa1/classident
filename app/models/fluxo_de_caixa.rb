class FluxoDeCaixa < ActiveRecord::Base
  named_scope :atual, :conditions=>[:last]
  named_scope :da_clinica, lambda{|clinica_id| {:conditions=>["clinica_id=?", clinica_id]}}
  
  def voltar_para_a_data(data,clinica_id)
    debugger
    a_apagar = FluxoDeCaixa.all(:conditions=>["clinica_id=? and data>?", clinica_id, data])
    a_apagar.each() do |reg|
      reg.delete
    end
    return FluxoDeCaixa.da_clinica(clinica_id).last
  end
  
  def avancar_um_dia
    
  end
end
