class Converte
  
  def converte_cadastro 
    puts "Convertendo cadastro ..."
    f = File.open("doc/cadastro.txt" , "r")
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
     puts "Convertendo cadastro ..."
      f = File.open("doc/maladireta.txt" , "r")
      clinica = Clinica.find_by_nome("Recreio")
      line = f.gets
      while line = f.gets
        registro = line.split(";")
        puts registro[0]
        p = Paciente.find_by_nome(registro[0])
        if !p.nil?
          p.logradouro = registro[3]
          p.bairro = registro[4]
          p.cidade = registro[5]
          debugger
          #TODO trataer erro de data
          p.nascimento = registro[6].to_date
          p.uf = registro[7]
          p.cep = registro[8]
          p.telefone = registro[9]
          p.save
      end
      end
      f.close
  end
  
  def converte_debito
    puts "Convertendo débitos ...."
    f = File.open("doc/debito.txt" , "r")
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
    Recebimento.delete_all
    clinica = Clinica.find_by_nome("Recreio")
    line = f.gets
    while line = f.gets 
      r = Recebimento.new
      registro = line.split(";")
      debugger
      r.data = registro[1].to_date
      r.paciente_id = registro[2].to_i
      r.formas_recebimento_id = registro[3].to_i
      r.valor = registro[4].split(" ")[1]
      r.observacao = registro[7]
      puts registro[8]
      r.save
    end
    f.close
  end
  #TODO continuar com a conversao de tabela , item tabela, tratamento etc ...
end