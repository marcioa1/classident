require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe Clinica do
  fixtures :pacientes, :clinicas
  
  before(:each) do
     @clinica = clinicas(:recreio)
   end
 
  it "deve ter dois paciente" do
    @clinica.pacientes.should have(2).pacientes
  end
  
  it "deve ter uma clinica" do
    Clinica.todas.should have(1).paciente
  end    
  
end
