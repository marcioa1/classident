class Converte

  
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
      p.nome = registro[0]
      p.id = registro[1].to_i
      p.tabela_id = registro[2].to_i
      p.clinica_id = clinica.id
      p.inicio_tratamento = registro[7].to_date
      p.save
    end
    f.close
  end
  
  def mala_direta
    #TODO considerar que pode haver outras pessoas que não sejam pacientes
     puts "Convertendo cadastro ..."
      f = File.open("doc/maladireta.txt" , "r")
      clinica = Clinica.find_by_nome("Recreio")
      line = f.gets
      while line = f.gets
        registro = line.split(";")
     #   puts registro[0]
        p = Paciente.find_by_nome(registro[0])
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
  
  def converte_debito
    puts "Convertendo débitos ...."
    f = File.open("doc/debito.txt" , "r")
    #FIXME  NA conversao real, não apagar tabela
    Debito.delete_all
    clinica = Clinica.find_by_nome("Recreio")
    line = f.gets
    while line = f.gets 
      d = Debito.new
      registro = line.split(";")
      d.paciente_id = registro[0].to_i
      d.data = registro[1].to_date
      d.valor = registro[2].split(" ")[1]
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
      r.nome = registro[0]
      r.id = registro[1].to_i
      r.save
    end
    f.close
    
  end
  
  def converte_recebimento
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
      r.paciente_id = registro[2].to_i
      r.formas_recebimento_id = registro[3].to_i
      r.valor = registro[4].split(" ")[1]
      r.observacao = registro[7]
      r.clinica_id = clinica.id
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
      t.nome = registro[1]
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
    puts "Convertendo tratamentos ...."
    f = File.open("doc/odontograma.txt" , "r")
    Tratamento.delete_all
    #FIXME  NA conversao real, não apagar tabela
    clinica = Clinica.find_by_nome("Recreio")
    line = f.gets
    while line = f.gets 
      registro = line.split(";")
      t = Tratamento.new
      t.paciente_id = registro[2].to_i
      t.item_tabela_id = registro[9].to_i
      t.dentista_id = registro[1].to_i
      t.valor = registro[6].split(" ")[1]
      t.data = registro[7].to_date unless registro[7].blank?
      t.dente = registro[4]
      t.orcamento_id = registro[8].to_i
      t.clinica_id = clinica.id
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
        t.id = registro[0].to_i
        t.nome = registro[1]
        t.cro = registro[2]
        t.ativo = true # TODO registro[5].to_i==0
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
        t.nome = registro[1]
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
#        debugger
        t.valor_pago = registro[2].split(" ")[1]
        t.observacao = registro[4]
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
      t.saldo_em_dinheiro = registro[1].split(" ")[1]
      t.saldo_em_cheque = registro[2].split(" ")[1]
      t.save
    end
    f.close
  end
  
end