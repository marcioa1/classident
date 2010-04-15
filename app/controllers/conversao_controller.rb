class ConversaoController < ApplicationController

def index
  converte = Converte.new
#  converte.clinicas
#  converte.tabela
#  converte.item_tabela
#  converte.dentista
#  converte.cadastro 
#  converte.mala_direta
#  converte.debito
  converte.formas_recebimento
#  converte.tratamento
#  converte.orcamento
  converte.tipo_pagamento
#  converte.destinacao
  converte.pagamento
#  converte.fluxo_de_caixa
  converte.recebimento
  converte.cheque
#  converte.protetico
#  converte.tabela_protetico
#  converte.trabalho_protetico
#  converte.alta
end

end
