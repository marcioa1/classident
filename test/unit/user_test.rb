require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_pode_incluir_user
    fabiana = users(:fabiana)
    assert fabiana.pode_incluir_user
    sandra = users(:sandra)
    assert sandra.pode_incluir_user==false
  end
  
  def test_pode_incluir_tabela
    fabiana = users(:fabiana)
    assert fabiana.pode_incluir_tabela
    sandra = users(:sandra)
    assert sandra.pode_incluir_tabela==false
  end
  
  def test_master
    fabiana = users(:fabiana)
    assert fabiana.master==false
    ricardo = users(:ricardo)    
    assert ricardo.master==true
  end
end
