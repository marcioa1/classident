require 'spec_helper'

describe Debito do

  fixtures :debitos
  
  it "pacientes em debito tem que conter um paciente" do
    
  end
  
  it "deve reconhecer se um décito está excluido" do
    deb = debitos(:excluido)
    deb.should be_excluido
  end
  
  it "deve saber se o débito pode ser excluido ou não" do
    debito = debitos(:tratamento)
    debito.should_not be_pode_excluir
    pode = debitos(:first)
    pode.should be_pode_excluir
  end
  
end
