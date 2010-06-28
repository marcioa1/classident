#require 'spec_helper'
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Paciente do
  fixtures :pacientes, :tabelas, :recebimentos, :debitos, :clinicas
  
  before(:each) do
    @paciente = pacientes(:marcio)
    @clinica = clinicas(:recreio)
    @tabela = tabelas(:principal)
  end
  
  it "should has a debt of 50" do
    @paciente.total_de_debito.real.should == BigDecimal.new('50').real
  end
  
  it "deve ter um recebimento de 30" do
    @paciente.credito.should == BigDecimal.new('30')
  end
  
  it "should have a saldo of -20 " do
      @paciente.saldo.should  == (-20)
  end
  
  it "should has a table" do
    @paciente.tabela != nil
  end
  
  it "should has a codigo of 2" do
    pac = Paciente.new
    pac.codigo = pac.gera_codigo(@clinica.id)
    pac.codigo.should == 3
  end
  
  it "should belongs to tabela Classident" do
    @paciente.tabela.should be == @tabela
  end
  
  it "nao é de ortodontia" do
    @paciente.ortodontia.should be(false)
  end
  
  it "não deve estar em alta" do
    @paciente.altas.size.should == 0
    @paciente.should_not be_em_alta
  end
  
end
