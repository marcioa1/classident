class ConversaoController < ApplicationController

def index
  apaga_arquivo_de_erros_de_conversao
  converte = Converte.new
  converte.inicia_arquivos_na_memoria
  converte.clinicas
  converte.tabela
  converte.item_tabela
  converte.dentista 
  converte.inicia_dentistas_em_memoria
  converte.cadastro  
  converte.mala_direta  
  converte.inicia_pacientes_em_memoria
  converte.orcamento
  converte.odontograma
  converte.debito 
  converte.tipo_pagamento 
  converte.destinacao 
  converte.pagamento 
  converte.fluxo_de_caixa 
  converte.formas_recebimento 
  converte.recebimento 
  converte.cheque 
  converte.protetico
  converte.tabela_protetico
  converte.trabalho_protetico
  # converte.alta
end

private
  def apaga_arquivo_de_erros_de_conversao
    @arquivo = File.open('doc/erros de conversao.txt', 'w') 
    @arquivo.close
  end
end
