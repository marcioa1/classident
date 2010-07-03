require 'spec_helper'

describe FluxoDeCaixa do
  
  fixtures :clinicas
  
  before(:each) do
    @clinica = clinicas(:recreio)
  end
  
  it "deve retornar a data atual de uma clínica" do
    data = Date.today - 1.day
    FluxoDeCaixa.data_atual(@clinica.id).should == data
  end
  
  it "deve retornar para a data de um pagamento se o mesmo for anterior a data atual" do
    fluxo     = FluxoDeCaixa.new(:clinica_id=>100, :saldo_em_cheque=>44, :saldo_em_dinheiro=>33, :data => Date.today)
    fluxo.save!
    pagamento = Pagamento.new
    pagamento.clinica_id=100
    pagamento.valor=10
    pagamento.data_de_pagamento=Date.today - 2.days
    if pagamento.save
      pagamento.verifica_fluxo_de_caixa
    end
    FluxoDeCaixa.atual(100).data.should == Date.today - 2.days
  end
  
end