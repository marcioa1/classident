#require 'spec_helper'
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Entrada do
  fixtures :entradas

  before(:each) do
    @entrada1 = entradas(:one)
    @entrada2 = entradas(:two)
  end
  
  it "Should be confirmada" do
    @entrada1.should be_confirmada
    @entrada2.should_not be_confirmada
  end
  
  it "Deve ter uma entrada confirmada" do  
    entradas_confirmadas = []
    entradas_confirmadas << @entrada1 if @entrada1.confirmada?
    entradas_confirmadas << @entrada2 if @entrada2.confirmada?
    entradas_confirmadas.should have(1).entrada
  end
end
