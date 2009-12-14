require 'test_helper'

class RecebimentoTest < ActiveSupport::TestCase

  def test_em_cheque
    em_dinheiro = recebimentos(:one)
    em_cheque = recebimentos(:two)
    assert !em_dinheiro.em_cheque?
    assert em_cheque.em_cheque?
  end
  
  def test_excluido?
    rec = recebimentos(:excluido)
    assert rec.excluido?
    assert Recebimento.excluidos.size==1
  end
end
