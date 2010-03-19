class Converte

  def clinicas
    todas = Clinica.all
    todas.each() do |cli|
      cli.dentistas = []
      cli.save
    end
  end  

  def converte_cadastro 
    puts "Convertendo cadastro ..."
    f = File.open("doc/cadastro.txt" , "r")
    #FIXME  NA conversao real, não apagar tabela
    Paciente.delete_all
    clinica = Clinica.find_by_nome("Recreio")
    line = f.gets
    while line = f.gets
      p = Paciente.new
      registro = line.split(";")
      p.nome = registro[0].nome_proprio
      #TODO não pode ser assim, pois em outras clinicas haverá outro paciente com o mesmo id/sequencial
      p.sequencial = registro[1].to_i
      p.tabela_id = registro[2].to_i
      p.clinica_id = clinica.id
      p.cpf = registro[16]
      p.sexo = registro[6].to_i ==0 ? "M" : "F"
      p.inicio_tratamento = registro[7].to_date
      p.sair_da_lista_de_debitos = registro[29]
      p.motivo_sair_da_lista_de_debitos = registro[30]
      p.data_da_saida_da_lista_de_debitos = registro[32].to_date unless registro[32].blank?
      if registro[34].to_i  > 0
        ortodontista = Dentista.find_by_sequencial(registro[34].to_i)
        p.ortodontia = true
        p.ortodontista_id = ortodontista.id
        p.mensalidade_de_ortodontia = le_valor(registro[33])
      else
        p.ortodontia = false
      end
      p.save
    end
    f.close
  end
  
  def mala_direta
    #TODO considerar que pode haver outras pessoas que não sejam pacientes
     puts "Convertendo mala direta ..."
      f = File.open("doc/maladireta.txt" , "r")
      clinica = Clinica.find_by_nome("Recreio")
      line = f.gets
      while line = f.gets
        registro = line.split(";")
     #   puts registro[0]
        p = Paciente.find_by_nome(registro[0].nome_proprio)
        if !p.nil?
          p.logradouro = registro[3]
          p.bairro = registro[4]
          p.cidade = registro[5]
          p.nascimento = registro[6].to_date
          p.uf = registro[7]
          p.cep = registro[8][0..7]
          p.telefone = registro[9]
          p.save
      end
      end
      f.close
  end
  
  def debito
    puts "Convertendo débitos ...."
    f = File.open("doc/debito.txt" , "r")
    #FIXME  NA conversao real, não apagar tabela
    Debito.delete_all
    clinica = Clinica.find_by_nome("Recreio")
    line = f.gets
    while line = f.gets 
      d = Debito.new
      registro = line.split(";")
      pac = Paciente.find_by_sequencial(registro[0].to_i)
     # puts pac.nome
      d.paciente_id = pac.id unless pac.nil?
      d.data = registro[1].to_date
      d.valor = le_valor(registro[2])
      d.descricao = registro[3]
      d.tratamento_id = registro[10].to_i
      d.save
    end
    f.close
  end
  
  def converte_formas_recebimento
    puts "Convertendo formas de recebimentos ...."
    f = File.open("doc/formarec.txt" , "r")
    #FIXME  NA conversao real, não apagar tabela
    FormasRecebimento.delete_all
    clinica = Clinica.find_by_nome("Recreio")
    line = f.gets
    while line = f.gets 
      r = FormasRecebimento.new
      registro = line.split(";")
      r.nome = registro[0].nome_proprio
      r.id = registro[1].to_i
      r.save
    end
    f.close
    
  end
  
  def recebimento
    puts "Convertendo recebimentos ...."
    f = File.open("doc/recebimento.txt" , "r")
    #FIXME  NA conversao real, não apagar tabela
    Recebimento.delete_all
    clinica = Clinica.find_by_nome("Recreio")
    line = f.gets
    while line = f.gets 
      r = Recebimento.new
      registro = line.split(";")
      r.data = registro[1].to_date
      pac = Paciente.find_by_sequencial(registro[2].to_i)
      r.paciente_id = pac.id unless pac.nil?
      r.formas_recebimento_id = registro[3].to_i
      r.valor = le_valor(registro[4])
      r.observacao = registro[7]
      r.sequencial = registro[8].to_i
      r.clinica_id = clinica.id
      r.data_de_exclusao = registro[12].to_date unless registro[12].blank?
      r.observacao_exclusao = registro[14]
    #  puts registro[8]
      r.save
    end
    f.close
  end
  
  def tabela
    puts "Convertendo tabelas ...."
    f = File.open("doc/tabela_nova.txt" , "r")
    Tabela.delete_all
    #FIXME  NA conversao real, não apagar tabela
    clinica = Clinica.find_by_nome("Recreio")
    line = f.gets
    while line = f.gets 
      registro = line.split(";")
      t = Tabela.new
      t.id = registro[0].to_i
      t.nome = registro[1].nome_proprio
      t.ativa = (registro[5].to_i == 0)
      t.save
    end
    f.close
  end
  
  def item_tabela
    puts "Convertendo item das tabelas ...."
    f = File.open("doc/item_tabela.txt" , "r")
    ItemTabela.delete_all
    #FIXME  NA conversao real, não apagar tabela
    clinica = Clinica.find_by_nome("Recreio")
    line = f.gets
    while line = f.gets 
      registro = line.split(";")
      t = ItemTabela.new
      t.id = registro[0].to_i
      t.tabela_id = registro[1].to_i
      t.codigo = registro[2]
      t.descricao = registro[3]
      t.save
      Preco.create(:item_tabela_id=> t.id, :clinica_id=>clinica.id, 
               :preco=>registro[4].split(" ")[1])
    end
    f.close
  end
  
  def tratamento
    #TODO colocar descricao do tratamento na tabela e na conversão
    puts "Convertendo tratamentos ...."
    f = File.open("doc/odontograma.txt" , "r")
    Tratamento.delete_all
    #FIXME  NA conversao real, não apagar tabela
    clinica = Clinica.find_by_nome("Recreio")
    line = f.gets
    while line = f.gets 
      registro = line.split(";")
      t = Tratamento.new
      t.sequencial = registro[0].to_i
      t.paciente_id = registro[2].to_i
      t.item_tabela_id = registro[9].to_i
      if !registro[1].blank?
        dentista = Dentista.find_by_sequencial(registro[1].to_i)
        t.dentista_id = dentista.id unless dentista.nil?
      end
      t.valor = le_valor(registro[6])
      t.data = registro[7].to_date unless registro[7].blank?
      t.dente = registro[3]
      t.face = registro[4]
      t.descricao = registro[5]
      t.orcamento_id = registro[8].to_i
      t.custo = le_valor(registro[12])
      t.excluido = registro[16].to_i != 0
      t.clinica_id = clinica.id
      t.created_at = registro[14].to_date
      t.save
    end
    f.close
  end
  
  def dentista
    puts "Convertendo dentistas ...."
    f = File.open("doc/dentista.txt" , "r")
    Dentista.delete_all
    #FIXME  NA conversao real, não apagar tabela
    clinica = Clinica.find_by_nome("Recreio")
    line = f.gets
    while line = f.gets 
      registro = line.split(";")
      t = Dentista.new
      t.sequencial = registro[0].to_i
      t.nome = registro[1].nome_proprio
      t.cro = registro[2]
      t.ativo = registro[5].to_i==1
      t.percentual = registro[4].sub(",",".") unless registro[4].blank?
      t.especialidade = registro[3]
      t.save
      clinica.dentistas << t
    end
    clinica.save
    f.close
  end
  
  def tipo_pagamento
     puts "Convertendo tipos de pagamentos ...."
      f = File.open("doc/tipo_pagamento.txt" , "r")
      TipoPagamento.delete_all
      #FIXME  NA conversao real, não apagar tabela
      clinica = Clinica.find_by_nome("Recreio")
      line = f.gets
      while line = f.gets 
        registro = line.split(";")
        t = TipoPagamento.new
        t.id = registro[0].to_i
        t.nome = registro[1].nome_proprio
        t.ativo = (registro[2].to_i==0)
        t.clinica_id = clinica.id
        t.save
      end
      f.close
  end
  
  def pagamento
    puts "Convertendo pagamentos ...."
      f = File.open("doc/pagamento.txt" , "r")
      Pagamento.delete_all
      #FIXME  NA conversao real, não apagar tabela
      clinica = Clinica.find_by_nome("Recreio")
      line = f.gets
      while line = f.gets 
        registro = line.split(";")
        t = Pagamento.new
        t.clinica_id = clinica.id
        t.tipo_pagamento_id = registro[1].to_i
        t.data_de_pagamento = registro[3].to_date
        t.sequencial = registro[6].to_i
        t.valor_pago = le_valor(registro[2])
        t.observacao = registro[4]
        t.valor_restante = le_valor(registro[13]) unless registro[13].blank?
        t.valor_cheque = le_valor(registro[11]) unless registro[11].blank?
        t.valor_terceiros = le_valor(registro[10]) unless registro[10].blank?
        t.conta_bancaria_id = registro[14].to_i unless registro[14].to_i == -1 
        t.numero_do_cheque = registro[15]
        t.nao_lancar_no_livro_caixa = (registro[16].to_i!= 0)
        t.data_de_exclusao = registro[17].to_date unless registro[17].blank?
        t.save
      end
      f.close
  end
  
  def fluxo_de_caixa
    puts "Convertendo fluxo de caixa ...."
    f = File.open("doc/saldos.txt" , "r")
    FluxoDeCaixa.delete_all
    #FIXME  NA conversao real, não apagar tabela
    clinica = Clinica.find_by_nome("Recreio")
    line = f.gets
    while line = f.gets 
      registro = line.split(";")
      t = FluxoDeCaixa.new
      t.clinica_id = clinica.id
      t.data = registro[0].to_date
      t.saldo_em_dinheiro = le_valor(registro[1])
      t.saldo_em_cheque = le_valor(registro[2])
      puts t.saldo_em_dinheiro
      t.save
    end
    f.close
  end
  
  def cheque
    #TODO Os cheques das clíncas existem na administração. Preciso tratar isto
    puts "Convertendo cheques ...."
    f = File.open("doc/cheque.txt" , "r")
   # Banco.delete_all
    Cheque.delete_all
    #TODO verificar se o cheque está disponível
    #FIXME  NA conversao real, não apagar tabela
    clinica = Clinica.find_by_nome("Recreio")
    line = f.gets
    while line = f.gets 
      registro = line.split(";")
      t = Cheque.new
      t.clinica_id = clinica.id
      t.sequencial = registro[0].to_i
      verifica_existencia_do_banco(registro[2].to_i)
      t.banco_id = Banco.find_by_numero(registro[2].to_i).id
      t.agencia = registro[3]
      t.conta_corrente = registro[4]
      t.numero = registro[5]
      t.bom_para = registro[6].to_date
      t.valor = le_valor(registro[7])
      pac = Paciente.find_by_sequencial(registro[8].to_i)
      t.paciente_id = pac.id unless pac.nil?
      t.data = registro[9].to_date
      if !registro[10].blank? && registro[10].to_i > 0
        d = Destinacao.find_by_sequencial(registro[10].to_i)
        if !d.nil?
          t.destinacao_id = d.id 
          t.data_destinacao = registro[11].to_date
        end
      end
      rec = Recebimento.find_by_sequencial(registro[29].to_i)
      t.recebimento_id = rec.id unless rec.nil?
      t.segundo_paciente = registro[15].to_i
      t.terceiro_paciente = registro[16].to_i
      t.data_primeira_devolucao = registro[18].to_date unless registro[18].blank?
      t.motivo_primeira_devolucao = registro[19] unless registro[19].blank?
      t.data_lancamento_primeira_devolucao = registro[20].to_date unless registro[20].blank?
      t.data_reapresentacao = registro[21].to_date unless registro[21].blank?
      t.data_segunda_devolucao = registro[22].to_date unless registro[22].blank?
      t.motivo_segunda_devolucao = registro[23]
      t.data_solucao = registro[24].to_date unless registro[24].blank?
      t.descricao_solucao = registro[25]
      t.reapresentacao = nil
      t.data_spc = nil
      t.data_arquivo_morto = registro[30].to_date unless registro[30].blank?
      t.data_recebimento_na_administracao = nil
      if !registro[12].blank?
        pag = Pagamento.find_by_sequencial(registro[12].to_i)
        t.pagamento_id = pag.id unless pag.nil?
      else
        t.pagamento_id = nil
      end
      if registro[13].to_i != 0
        t.data_entrega_administracao = registro[14].to_date
        t.data_recebimento_na_administracao = registro[14].to_date
      else
        t.data_recebimento_na_administracao = nil
      end
      t.data_de_exclusao = registro[28].to_date unless registro[28].blank?
      t.save
      if !rec.nil?
        rec.cheque_id = t.id
        rec.observacao = t.banco.nome + " - " + t.numero if rec.observacao.nil? or rec.observacao.blank?
        rec.save
      end
    end
    f.close
  end
  
  def destinacao
    puts "Convertendo destinacao ...."
    f = File.open("doc/destinacao.txt" , "r")
    Destinacao.delete_all
    #FIXME  NA conversao real, não apagar tabela
    clinica = Clinica.find_by_nome("Recreio")
    line = f.gets
    while line = f.gets 
      registro = line.split(";")
      t = Destinacao.new
      t.clinica_id = clinica.id
      t.sequencial = registro[0]
      t.nome = registro[1].nome_proprio
      t.save
    end
    f.close
  end
  
  def orcamento
    puts "Convertendo orçamento ...."
    f = File.open("doc/orcamento.txt" , "r")
    Orcamento.delete_all
    #FIXME  NA conversao real, não apagar tabela
    clinica = Clinica.find_by_nome("Recreio")
    line = f.gets
    while line = f.gets 
      registro = line.split(";")
      o = Orcamento.new
      o.id = registro[0]
      o.clinica_id = clinica.id
      o.data = registro[1].to_date
      o.paciente_id = registro[2].to_i
      o.dentista = Dentista.find_by_sequencial(registro[3].to_i)
      o.numero = registro[4]
      o.numero_de_parcelas = registro[6].to_i
      o.valor_da_parcela = le_valor(registro[7])
      o.vencimento_primeira_parcela = registro[8].to_date unless registro[8].blank?
      #FIXME traduzir isto aqui para as formas conhecidas
      o.forma_de_pagamento = 'cheque_pre' if registro[9]=='P'
      o.forma_de_pagamento = 'a_vista' if registro[9]=='V'
      o.forma_de_pagamento = 'cartao' if registro[9]=='C'
      o.data_de_inicio = registro[10].to_date unless registro[10].blank?
      o.valor_com_desconto = le_valor(registro[12])
      o.desconto = registro[13].to_i
      o.valor = o.valor_com_desconto / (100 - (o.desconto / 100)) * 100
      o.save
    end
    f.close
  end
  
  def protetico
    puts "Convertendo protéticos ...."
    f = File.open("doc/protetico.txt" , "r")
    Protetico.delete_all
    #FIXME  NA conversao real, não apagar tabela
    clinica = Clinica.find_by_nome("Recreio")
    line = f.gets
    while line = f.gets 
      registro = line.split(";")
      p = Protetico.new
      p.sequencial = registro[0].to_i
      p.clinicas << clinica
      p.nome = registro[1].nome_proprio
      p.logradouro = registro[2]
      p.bairro = registro[3]
      p.cidade = registro[4]
      p.estado = registro[5]
      p.cep = registro[6]
      p.telefone = registro[7]
      p.email = registro[8]
      p.cpf = registro[9]
      p.nascimento = registro[10].to_date unless registro[10].blank?
      p.save
    end
    f.close 
  end
  
  def tabela_protetico
    #Tabela base
    puts "Convertendo tabela base de protéticos ...."
    f = File.open("doc/tabelaprotetico.txt" , "r")
    TabelaProtetico.delete_all
    #FIXME  NA conversao real, não apagar tabela
    clinica = Clinica.find_by_nome("Recreio")
    line = f.gets
    while line = f.gets 
      registro = line.split(";")
      t = TabelaProtetico.new
      t.sequencial = registro[0].to_i
      t.protetico_id = nil
      t.codigo = ''
      t.descricao = registro[1]
      t.valor = le_valor(registro[2])
      t.save
    end
    f.close
    # tabelas dos proteticos
    puts "Convertendo tabela de protéticos ...."
    f = File.open("doc/itemProtetico.txt" , "r")
    line = f.gets
    while line = f.gets 
      registro = line.split(";")
      t = TabelaProtetico.new
      t.sequencial = registro[0].to_i
      t.protetico_id = Protetico.find_by_sequencial(registro[1].to_i).id
      t.codigo = ''
      t.descricao = registro[2]
      t.valor = le_valor(registro[3])
      t.save
    end
    f.close
  end
  
  def trabalho_protetico
    puts "Convertendo trabalho protético ...."
    f = File.open("doc/noprotetico.txt" , "r")
    TrabalhoProtetico.delete_all
    #FIXME  NA conversao real, não apagar tabela
    clinica = Clinica.find_by_nome("Recreio")
    line = f.gets
    linha = 0
    while line = f.gets 
      registro = line.split(";")
      #puts linha #registro[1] + ";"  +registro[1] + ";" + registro[2]
      linha += 1
      t = TrabalhoProtetico.new
      t.clinica_id = clinica.id
      #FIXME Preciso da clinica também para achar o dentista
      dentista = Dentista.find_by_sequencial(registro[10].to_i)
      t.dentista_id = dentista.id unless dentista.nil?
      p = Protetico.find_by_sequencial(registro[0].to_i)
      t.protetico = p unless p.nil?
      paciente = Paciente.find_by_sequencial(registro[1].to_i)
      t.paciente = paciente #.id unless paciente.nil?
      t.dente = registro[6]
      begin
        t.data_de_envio = registro[3].to_date unless registro[3].blank?
        t.data_prevista_de_devolucao = registro[5].to_date unless registro[5].blank? or registro[5].nil?
        t.data_de_devolucao = registro[4].to_date unless registro[4].blank?
        t.data_de_repeticao = registro[12].to_date unless registro[12].blank?
        t.data_prevista_da_devolucao_da_repeticao = registro[15].to_date unless registro[15].blank?
      rescue
      end
      tabela = TabelaProtetico.find_by_sequencial(registro[8].to_i)
      t.tabela_protetico = tabela unless tabela.nil?
      t.valor = le_valor(registro[7]) unless registro[7].nil?
      t.cor = registro[11]
      t.observacoes = registro[9]
      t.motivo_da_repeticao = registro[13]
      t.pagamento_id = 0
      #TODO definir como registrar que foi pago
      t.save
    end
    f.close
  end
  
  def alta
    puts "Convertendo altas ...."
    Paciente.all.each do |p|  
      t = Tratamento.all(:conditions=>['paciente_id = ? and data IS NULL', p])
      if t.empty?
        ultimo = Tratamento.last(:conditions=>['paciente_id = ? and data IS NOT NULL', p], :order=>'data desc')
        alta = Alta.new
        alta.clinica_id = 5
        #FIXME fazer para todas as clínicas
        alta.paciente = p
        if ultimo.nil?
          alta.data_inicio = Date.today
        else
          alta.data_inicio = ultimo.data
        end
        alta.observacao = 'gerada pela conversão'
        alta.user_id = 1
        alta.save
      end
    end
  end
  
  private
  
  def verifica_existencia_do_banco(numero)
    b  = Banco.find_by_numero(numero)
    if b.nil?
      Banco.create(:numero=>numero, :nome=>numero)
    end
  end
  
  def le_valor(val)
    return 0 if val.nil?
    aux = val.split(" ")[1]
    return 0 if aux.nil?
    aux = aux.sub(".","")
    aux = aux.sub(",",".")
    return aux
  end
  
end