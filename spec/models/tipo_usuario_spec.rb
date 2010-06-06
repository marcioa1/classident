require 'spec_helper'

describe TipoUsuario do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    TipoUsuario.create!(@valid_attributes)
  end
end
