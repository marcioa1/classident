require 'spec_helper'

describe Clinica do
  before(:each) do
    @valid_attributes = {
      :nome => "value for nome"
    }
  end

  it "should create a new instance given valid attributes" do
    Clinica.create!(@valid_attributes)
  end
end
