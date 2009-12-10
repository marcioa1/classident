class ConversaoController < ApplicationController

def index
  c = Converte.new
 # c.tabela
#  c.item_tabela
#  c.converte_cadastro 
#  c.mala_direta
#  c.converte_debito
#  c.converte_formas_recebimento
#  c.converte_recebimento
#  c.tratamento
#  c.dentista
#   c.tipo_pagamento
#   c.pagamento
  c.fluxo_de_caixa
end

end
