class ConversaoController < ApplicationController

def index
  @arquivo = File.open('doc/erros de conversao.txt', 'w') 
  @arquivo.close
  converte = Converte.new
  # converte.clinicas
  # converte.tabela
  # converte.item_tabela
  # converte.dentista #
  # converte.cadastro  #
  # converte.mala_direta  #
  # converte.orcamento
  # converte.odontograma
  # converte.debito #
  # converte.tipo_pagamento #
  # converte.destinacao #
  # converte.pagamento #
  # converte.fluxo_de_caixa #
  # converte.formas_recebimento # 
  converte.recebimento #
  converte.cheque #
  converte.protetico
  converte.tabela_protetico
  converte.trabalho_protetico
  converte.alta
end

end
