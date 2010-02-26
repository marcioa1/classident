#require 'spec_helper'
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Paciente do
  fixtures :pacientes, :tabelas, :recebimentos, :debitos
  
  it "should be invalid without a nome" do
    lambda{
      paciente = create_paciente(:nome=>nil)
      paciente.errors.should be_invalid(:nome)
    }.should_not change(Paciente, :count)
  end

  it "should be invalid without a tabela" do
    lambda{
      paciente = create_paciente(:tabela=>nil)
      paciente.errors.should be_invalid(:tabela)
    }.should_not change(Paciente, :count)
  end
  
  it "should have a saldo of 0 when created" do
    lambda{
      paciente = create_paciente()
      paciente.saldo.should == 1
    }
  end
  
  private
     def create_paciente(options={})
       Paciente.create({
         :nome => "Marcio", 
         :tabela=> tabelas(:principal)
       }.merge(options))
     end
end
