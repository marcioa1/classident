#require 'spec_helper'
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Paciente do
  fixtures :pacientes, :tabelas, :recebimentos, :debitos, :clinicas
  
  before(:each) do
    @paciente = pacientes(:marcio)
    @clinica = clinicas(:recreio)
  end
  
  it "should has a debt of 50" do
    @paciente.debito.real.should == BigDecimal.new('50').real
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
    pac.codigo.should == 2
  end

end
