require 'spec_helper'

describe Tratamento do
  fixtures :tratamentos

  it "não deve poder alterar o tratamento fora da quinzena" do
    tratamento = tratamentos(:one)
    tratamento.should_not be_pode_alterar
    tratamento2 = tratamentos(:two)
    tratamento2.should be_pode_alterar
  end
  
end
