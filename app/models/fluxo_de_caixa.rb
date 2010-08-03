class FluxoDeCaixa < ActiveRecord::Base
  
  acts_as_audited
  named_scope :da_clinica, lambda{|clinica_id| {:conditions=>["clinica_id=?", clinica_id]}}
  named_scope :saldo_na_data, lambda{|data| {:conditions=>['data = ?', data]}}
  named_scope :por_data, :order => 'data desc'
  
  def self.voltar_para_a_data(data,clinica_id)
    a_apagar = FluxoDeCaixa.all(:conditions=>["clinica_id=? and data>?", clinica_id, data])
    a_apagar.each() do |reg|
      reg.delete
    end
    return FluxoDeCaixa.da_clinica(clinica_id).last
  end
  
  def self.avancar_um_dia(clinica_id,saldo_em_dinheiro,saldo_em_cheque)
    saldo_em_cheque = saldo_em_cheque.gsub('.','').sub(',','.')
    saldo_em_dinheiro = saldo_em_dinheiro.gsub('.','').sub(',','.')
    return FluxoDeCaixa.create(:data => FluxoDeCaixa.atual(clinica_id).data + 1.day ,
       :saldo_em_cheque => saldo_em_cheque,
       :saldo_em_dinheiro => saldo_em_dinheiro,
       :clinica_id => clinica_id)
  end
  
  def self.data_atual(clinica_id)
    begin
      FluxoDeCaixa.last(:conditions=>['clinica_id = ?', clinica_id]).data 
    rescue 
      FluxoDeCaixa.create(:data=>Date.today, :saldo_em_dinheiro =>0, :saldo_em_cheque=>0)
      Date.today
    end
  end
  
  def self.atual(clinica_id)
    return FluxoDeCaixa.da_clinica(clinica_id).por_data.first
  end
  
end
