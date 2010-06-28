require 'spec_helper'

describe Debito do

  fixtures :debitos
  
  it "pacientes em debito tem que conter um paciente" do
    
  end
  
  it "deve reconhecer se um décito está excluido" do
    deb = debitos(:excluido)
    deb.should be_excluido
  end
end
