require 'spec_helper'

describe User do
  fixtures :users

  it "deve ser usuario master para atualizar saldo do fluxo de caixa" do
    user_master = users(:usuario_master)
    user_master.tipo_usuario.nivel should == 0
  end
  
end
