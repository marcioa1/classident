class FluxoDeCaixa < ActiveRecord::Base
  
  named_scope :atual, :conditions=>[:last]
  named_scope :da_clinica, lambda{|clinica_id| {:conditions=>["clinica_id=?", clinica_id]}}
  named_scope :saldo_na_data, lambda{|data| {:conditions=>['data = ?', data]}}
  
  def voltar_para_a_data(data,clinica_id)
    a_apagar = FluxoDeCaixa.all(:conditions=>["clinica_id=? and data>?", clinica_id, data])
    a_apagar.each() do |reg|
      reg.delete
    end
    return FluxoDeCaixa.da_clinica(clinica_id).last
  end
  
  def avancar_um_dia(clinica_id,data,saldo_em_dinheiro,saldo_em_cheque)
    return FluxoDeCaixa.create(:data => data ,
       :saldo_em_cheque => saldo_em_cheque,
       :saldo_em_dinheiro => saldo_em_dinheiro,
       :clinica_id => clinica_id)
  end
  
end
