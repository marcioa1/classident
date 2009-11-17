require 'test_helper'

class ItemTabelaTest < ActiveSupport::TestCase
  def test_preco_na_clinica
     centro = clinicas(:centro)
     barra = clinicas(:barra)
     tabela = tabelas(:classident)
     item = item_tabelas(:ama1)
     assert item.preco_na_clinica(centro.id) ==12.0
     assert item.preco_na_clinica(barra.id) ==14.5
   end
end
