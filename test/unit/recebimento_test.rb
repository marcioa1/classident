require 'test_helper'

class RecebimentoTest < ActiveSupport::TestCase

  def test_em_cheque
    em_dinheiro = recebimentos(:one)
    em_cheque = recebimentos(:two)
    assert !em_dinheiro.em_cheque?
    assert em_cheque.em_cheque?
  end
end
