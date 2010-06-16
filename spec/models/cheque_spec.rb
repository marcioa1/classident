require 'spec_helper'

describe Cheque do
  fixtures :recebimentos, :pacientes, :cheques
  
  it "Deve ser um cheque para dois recebimentos" do
    cheque = cheques(:um)
    cheque.should have(2).recebimentos
  end



end
