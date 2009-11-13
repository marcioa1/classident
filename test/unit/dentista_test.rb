require 'test_helper'

class DentistaTest < ActiveSupport::TestCase
  
  def test_clinica_dentista
    joao = dentistas(:joao)
    debugger
    assert joao.clinicas.size==2
  end
end
