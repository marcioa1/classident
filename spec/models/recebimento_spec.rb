require 'spec_helper'

describe Recebimento do
  
  fixtures :cheques, :recebimentos, :pacientes, :formas_recebimentos
  
  it "Paciente 'Marcio' deve ter 1 recebimento" do
    marcio = pacientes(:marcio)
    marcio.recebimentos.should have(1).recebimento
  end
  
  it "deve ser do tipo cheque" do
    recebimento = recebimentos(:um)
    recebimento.should be_em_cheque
  end
  
end
