require 'test_helper'

class PacienteTest < ActiveSupport::TestCase
   def test_saldo
     marcio = pacientes(:marcio)
     assert marcio.saldo == -44.0
   end
end
