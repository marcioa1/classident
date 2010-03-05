class ConversaoController < ApplicationController

def index
  c = Converte.new
#  c.clinicas
#  c.tabela
#  c.item_tabela
#  c.dentista
#  c.converte_cadastro 
#  c.mala_direta
#  c.converte_debito
#  c.converte_formas_recebimento
#  c.tratamento
#  c.orcamento
#  c.tipo_pagamento
#  c.destinacao
#  c.pagamento
#  c.fluxo_de_caixa
  c.recebimento
  c.cheque
#  c.protetico
#  c.tabela_protetico
#  c.trabalho_protetico
#  c.alta
end

end
