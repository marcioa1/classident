require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe Clinica do
  fixtures :pacientes, :clinicas
  
  before(:each) do
     @clinica = clinicas(:recreio)
   end
 
  it "deve ter dois paciente" do
    @clinica.pacientes.size.should be == 2
  end
  
  it "deve ter uma clinica" do
    Clinica.todas.size.should be == 1
  end    
  
end
