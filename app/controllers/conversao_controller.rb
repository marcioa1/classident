class ConversaoController < ApplicationController

def index
  c = Converte.new
  c.clinicas
#  c.tabela
#  c.item_tabela
#  c.converte_cadastro 
#  c.mala_direta
#  c.converte_debito
#  c.converte_formas_recebimento
  c.dentista
  c.tratamento
 
#  c.tipo_pagamento
#   c.destinacao
#   c.pagamento
#   c.fluxo_de_caixa
#   c.recebimento
#   c.cheque
end

end
