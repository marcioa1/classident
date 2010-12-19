class ConversaoController < ApplicationController

def index
  apaga_arquivo_de_erros_de_conversao
  converte = Converte.new
  converte.inicia_arquivos_na_memoria
   converte.clinicas
   converte.tabela
   converte.inicia_tabelas_em_memoria
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
   converte.alta
   converte.adm_tipo_pagamento
   converte.adm_pagamento
   converte.adm_cheques
   converte.adm_fluxo
  puts "Término da conversão."
end

def cheque_adm
  @arquivo = File.open('doc/erros de conversao.txt', 'a')  
  @arquivo.puts '                '
  @arquivo.puts "Preparando arquivo de cheques adm em #{Time.current}"
  
  puts "Convertendo cheques na administração ...."
  f = File.open("doc/convertidos/adm_cheque.txt" , "r")
  n = File.open("doc/convertidos/adm_cheque_bom.txt" , "w")
  f.gets
  end_of_file = false
  line        = f.gets
  while !end_of_file 
    begin
      good       = line
      end_of_file = !(next_line  = f.gets)
      has_number = "0123456789".include?(next_line[0])
      if has_number
        n.puts line
        line = next_line
      else
        while !has_number
          good = good[0..good.size-3] + '. ' + next_line
          end_of_file = !(next_line  = f.gets)
          has_number = "0123456789".include?(next_line[0])
        end    
        n.puts good
        puts good
        line = next_line
      end
    rescue Exception => ex
      @arquivo.puts line + "\n"+ "      ->" + ex
    end # begin
  end #while
  n.puts line
  f.close
  n.close
  @arquivo.close
end

def teste
   f = File.open("doc/convertidos/teste.txt" , "r")
   line = f.gets
   @ar = line.split(';')
   @d  = Debito.last
   @d.descricao = @ar[3]
   @d.save
end

private
  def apaga_arquivo_de_erros_de_conversao
    @arquivo = File.open('doc/erros de conversao.txt', 'w') 
    @arquivo.close
  end
end
