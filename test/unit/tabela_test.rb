require 'test_helper'

class TabelaTest < ActiveSupport::TestCase
 
 def test_quantidade_de_items
   classident = tabelas(:classident)
   assert classident.item_tabelas.size==2
 end
 
end
