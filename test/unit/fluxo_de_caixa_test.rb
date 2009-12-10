require 'test_helper'

class FluxoDeCaixaTest < ActiveSupport::TestCase
  def test_abertura
    fluxo = fluxo_de_caixas(:ultimo)
    assert fluxo.data.to_date == "2009-12-10".to_date
  end
end
