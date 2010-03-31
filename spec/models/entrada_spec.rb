#require 'spec_helper'
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Entrada do
  fixtures :entradas

  before(:each) do
    @entrada1 = entradas(:one)
    @entrada2 = entradas(:two)
  end
  
  it "Should be confirmada" do
    @entrada1.confirmada?.should == true
    @entrada2.confirmada?.should == false
  end
  
  it "Deve ter uma entrada confirmada" do  
    entradas_confirmadas = []
    entradas_confirmadas << @entrada1 if @entrada1.confirmada?
    entradas_confirmadas << @entrada2 if @entrada2.confirmada?
    entradas_confirmadas.size.should be == 1
  end
end
