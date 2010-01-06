require 'test_helper'

class PacienteTest < ActiveSupport::TestCase
  
  
   def test_debito
     marcio = pacientes(:marcio)
     assert marcio.debito==70.0    
   end
   
   def test_credito
    marcio = pacientes(:marcio)
    assert marcio.credito == 26.0
   end
   
   def test_saldo
     marcio = pacientes(:marcio)
     assert marcio.saldo == -44.0
   end
   
   def test_criacao
     p = Paciente.new
     assert p.debito==0
     assert p.credito == 0   
     assert p.saldo ==0
   end
   
   def test_alta
     paciente = pacientes(:marcio)
     assert paciente.em_alta? == true
     outro = pacientes(:two)
     assert outro.em_alta? == false
   end
end
