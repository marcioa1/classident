class Converte

  def clinicas
    todas = Clinica.all
    todas.each() do |cli|
      cli.dentistas = []
      cli.save
    end
  end  

  def cadastro 
    abre_arquivo_de_erros('Cadastro')
    puts "Convertendo cadastro ..."
    f = File.open("doc/convertidos/cadastro.txt" , "r")
    tabela_inexistente = Tabela.find_by_nome('Inexistente')
    Paciente.delete_all
    clinica = ''
    while line = f.gets
      begin
        registro = busca_registro(line)
        if clinica != registro.last
          clinica  = registro.last
          @clinica = Clinica.find_by_sigla(clinica)
        end
        p                       = Paciente.new
        p.nome                  = registro[0].nome_proprio
        p.sequencial            = registro[1].to_i
        tabela                  = Tabela.find_by_sequencial_and_clinica_id(registro[2].to_i, @clinica.id)
        if tabela.present?
          p.tabela_id           = tabela.id 
        else
          p.tabela_id           = tabela_inexistente.id
        end
        p.clinica_id            = @clinica.id unless @clinica.nil?
        p.cpf                   = registro[16]
        p.sexo                  = registro[6].to_i == 0 ? "M" : "F"
        p.inicio_tratamento     = registro[7].to_date unless !Date.valid?(registro[7])
        p.sair_da_lista_de_debitos          = registro[29]
        p.motivo_sair_da_lista_de_debitos   = registro[30]
        p.data_da_saida_da_lista_de_debitos = registro[31].to_date unless !Date.valid?(registro[31])
        if registro[34].to_i  > 0
          ortodontista = Dentista.find_by_sequencial(registro[34].to_i)
          p.ortodontia = true
          p.ortodontista_id = ortodontista.id
          p.mensalidade_de_ortodontia = le_valor(registro[33])
        else
          p.ortodontia = false
        end
        p.save!
      rescue Exception => ex
        @arquivo.puts line + "\n"+ "      ->" + ex 
      end
    end
    f.close
    fecha_arquivo_de_erros('Cadastro')
  end
  
  def mala_direta
    #FIXME considerar que pode haver outras pessoas que não sejam pacientes
    abre_arquivo_de_erros('Mala-direta')
    puts "Convertendo mala direta ..."
    f = File.open("doc/convertidos/maladireta.txt" , "r")
    clinica = ''
    while line = f.gets
      begin
        registro = busca_registro(line)
        if clinica != registro.last
          clinica  = registro.last
          @clinica = Clinica.find_by_sigla(clinica)
        end
        p = Paciente.find_by_nome_and_clinica_id(registro[0].nome_proprio, @clinica.id)
        if !p.nil?
          p.logradouro   = registro[3]
          p.bairro       = registro[4]
          p.cidade       = registro[5]
          p.nascimento   = registro[6].to_date if Date.valid?(registro[6])
          p.uf           = registro[7]
          p.cep          = registro[8][0..7]
          p.telefone     = registro[9]
          p.save
        end
      rescue Exception => ex
        @arquivo.puts line + "\n"+ "      ->" + ex
      end
    end
    f.close
    fecha_arquivo_de_erros('Mala-direta')
  end
  
  def debito
    # Depende de tratamento
    abre_arquivo_de_erros('Débitos')
    puts "Convertendo débitos ...."
    f = File.open("doc/convertidos/debito.txt" , "r")
    Debito.delete_all
    clinica = ''
    while line = f.gets 
      begin
        registro = busca_registro(line)
        if clinica != registro.last
          clinica = registro.last
          @clinica = Clinica.find_by_sigla(clinica)
        end
        d               = Debito.new
        paciente        = Paciente.find_by_sequencial_and_clinica_id(registro[0].to_i, @clinica.id)
        d.paciente_id   = paciente.id unless paciente.nil?
        d.data          = registro[1].to_date
        d.valor         = le_valor(registro[2])
        d.descricao     = registro[3]
        d.tratamento_id = registro[10].to_i
        d.save
      rescue Exception => ex
        @arquivo.puts line + "\n"+ "      ->" + ex
      end
    end
    f.close
    fecha_arquivo_de_erros('Débitos')
  end
  
  def formas_recebimento
    abre_arquivo_de_erros('Formas de recebimento')
    puts "Convertendo formas de recebimentos ...."
    f = File.open("doc/convertidos/forma_rec.txt" , "r")
    FormasRecebimento.delete_all
    clinica = ''
    while line = f.gets 
      begin
        registro = busca_registro(line)
        if clinica != registro.last
          clinica = registro.last
          @clinica = Clinica.find_by_sigla(clinica)
        end
        forma_adm = FormasRecebimento.find_by_nome(registro[0].strip)
        if forma_adm.nil?
          forma_adm = FormasRecebimento.new
          forma_adm.nome = registro[0].strip
          forma_adm.save
        end
        forma_cli            = FormaRecebimentoTemp.new
        forma_cli.seq        = registro[1].to_i
        forma_cli.id_adm     = forma_adm.id
        forma_cli.clinica_id = @clinica_id
        forma_cli.save
      rescue Exception => ex
        @arquivo.puts line + "\n"+ "      ->" + ex
      end
    end
    f.close
    fecha_arquivo_de_erros('Formas de recebimento')
  end
  
  def recebimento
    abre_arquivo_de_erros("Recebimentos")
    puts "Convertendo recebimentos ...."
    f = File.open("doc/convertidos/recebimento.txt" , "r")
    Recebimento.delete_all
    clinica = ''
    while line = f.gets 
      begin
        r          = Recebimento.new
        registro   = busca_registro(line)
        if clinica != registro.last
          clinica  = registro.last
          @clinica = Clinica.find_by_sigla(clinica)
        end
        r.data                  = registro[1].to_date
        paciente                = Paciente.find_by_sequencial_and_clinica_id(registro[2].to_i, @clinica_id)
        r.paciente_id           = paciente.id unless paciente.nil?
        forma_recebimento       = FormaRecebimentoTemp.find_by_seq_and_clinica_id(registro[3].to_i, @clinica.id)
        r.formas_recebimento_id = forma_recebimento.id_adm if forma_recebimento.present?
        r.valor                 = le_valor(registro[4])
        r.observacao            = registro[7]
        r.sequencial            = registro[8].to_i
        r.clinica_id            = @clinica.id
        r.data_de_exclusao      = registro[12].to_date if Date.valid?(registro[12])
        r.observacao_exclusao   = registro[14]
        r.save
      rescue Exception => ex
        @arquivo.puts line + "\n"+ "      ->" + ex
      end
    end
    f.close
    fecha_arquivo_de_erros('Recebimento')
  end
  
  def tabela
    abre_arquivo_de_erros('Tabelas ....')
    puts "Convertendo tabelas ...."
    f = File.open("doc/convertidos/tabela_nova.txt" , "r")
    Tabela.delete_all
    Tabela.create!(:nome => 'Inexistente', :ativa => false)
    clinica = '' 
    while line = f.gets 
      begin
        registro = busca_registro(line)
        if clinica != registro.last
          clinica = registro.last
          @clinica = Clinica.find_by_sigla(clinica)
        end
        t              = Tabela.new
        t.sequencial   = registro[0].to_i
        t.nome         = registro[1].nome_proprio
        t.ativa        = (registro[5].to_i == 'Verdadeiro')
        t.clinica_id   = @clinica.id
        t.save
      rescue Exception => ex
        @arquivo.puts line + "\n"+ "      ->" + ex
      end
    end
    f.close
    fecha_arquivo_de_erros('Tabelas')
  end
  
  def item_tabela
    abre_arquivo_de_erros('Item tabelas ...')
    puts "Convertendo item das tabelas ...."
    f = File.open("doc/convertidos/item_tabela.txt" , "r")
    ItemTabela.delete_all
    Preco.delete_all
    clinica = ''
    while line = f.gets 
      begin
        registro = busca_registro(line)
        if clinica != registro.last
          clinica = registro.last
          @clinica = Clinica.find_by_sigla(clinica)
        end
        tabela = Tabela.find_by_sequencial_and_clinica_id(registro[1].to_i,@clinica.id)
        if !tabela.nil?
          t = ItemTabela.new
          t.sequencial = registro[0].to_i
          t.clinica_id = @clinica.id
          t.tabela_id = tabela.id
          t.codigo = registro[2]
          t.descricao = registro[3]
          t.save
          valor = le_valor(registro[4])
          Preco.create(:item_tabela_id=> t.id, :clinica_id=>@clinica.id, :preco=> valor)
        end
      rescue Exception => ex
        @arquivo.puts line + "\n"+ "      ->" + ex
      end
    end
    f.close
    fecha_arquivo_de_erros('Item Tabela')
  end
  
  def odontograma
    # depende de dentista
    #TODO colocar descricao do tratamento na tabela e na conversão
    abre_arquivo_de_erros('Odontograma')
    puts "Convertendo odontograma ...."
    f = File.open("doc/convertidos/odontograma.txt" , "r")
    Tratamento.delete_all
    clinica = ''
    while line = f.gets 
      begin
        registro = busca_registro(line)
        if clinica != registro.last
          clinica  = registro.last
          @clinica = Clinica.find_by_sigla(clinica)
        end
        t                 = Tratamento.new
        t.sequencial      = registro[0].to_i
        paciente          = Paciente.find_by_sequencial_and_clinica_id(registro[2].to_i, @clinica.id)
        t.paciente_id     = paciente.id if paciente.present?
        t.item_tabela_id  = registro[9].to_i
        if !registro[1].blank?
          dentista = Dentista.find_by_sequencial_and_clinica_id(registro[1].to_i, @clinica.id)
          t.dentista_id  = dentista.id unless dentista.nil?
        end
        t.valor          = le_valor(registro[6])
        t.data           = registro[7].to_date if Date.valid?(registro[7])
        t.dente          = registro[3]
        t.face           = registro[4]
        t.descricao      = registro[5]
        orcamento        = Orcamento.find_by_sequencial_and_clinica_id(registro[8].to_i, @clinica.id)
        t.orcamento_id   = orcamento.id if orcamento.present?
        t.custo          = le_valor(registro[12])
        t.excluido       = registro[16].to_i != 0
        t.clinica_id     = @clinica.id
        t.created_at     = registro[14].to_date if Date.valid?(registro[14])
        t.save
      rescue Exception => ex
        @arquivo.puts line + "\n"+ "      ->" + ex
      end
    end
    f.close
    fecha_arquivo_de_erros('odontograma')
  end
  
  def dentista
    abre_arquivo_de_erros('Dentistas')
    puts "Convertendo dentistas ...."
    f = File.open("doc/convertidos/dentista.txt" , "r")
    Dentista.delete_all
    clinica = ''
    while line = f.gets 
      begin
        registro = busca_registro(line)
        if clinica != registro.last
          @clinica.save if !clinica.blank?
          clinica  = registro.last
          @clinica = Clinica.find_by_sigla(clinica)
        end
        dentista                 = Dentista.new
        dentista.sequencial      = registro[0].to_i
        dentista.clinica_id      = @clinica.id
        dentista.nome            = registro[1].strip.nome_proprio
        dentista.cro             = registro[2].strip
        dentista.cro             = '?' if dentista.cro.blank?
        dentista.ativo           = registro[5] == 'True'
        dentista.percentual      = registro[4].sub(",",".") unless registro[4].blank?
        dentista.especialidade   = registro[3]
        dentista.save
        @clinica.dentistas << dentista
      rescue Exception => ex
        @arquivo.puts line + "\n"+ "      ->" + ex
      end
    end
    @clinica.save
    f.close
    fecha_arquivo_de_erros('Dentistas')
  end
  
  def tipo_pagamento
    abre_arquivo_de_erros('Tipo de Pagamento')
    puts "Convertendo tipos de pagamentos ...."
    f = File.open("doc/convertidos/tipo_pagamento.txt" , "r")
    TipoPagamento.delete_all
    clinica = ''
    while line = f.gets 
      begin
        registro = busca_registro(line)
        if clinica != registro.last
          clinica  = registro.last
          @clinica = Clinica.find_by_sigla(clinica)
        end
        t = TipoPagamento.new
        t.seq        = registro[0].to_i
        t.nome       = registro[1].nome_proprio
        t.ativo      = (registro[2]=='Verdadeiro')
        t.clinica_id = @clinica.id
        t.save
      rescue Exception => ex
        @arquivo.puts line + "\n"+ "      ->" + ex
      end
    end
    f.close
    fecha_arquivo_de_erros('Tipo de Pagamento')
  end
  
  def pagamento
    abre_arquivo_de_erros('Pagamentos')
    puts 'Convertendo pagamentos ... '
    f = File.open("doc/convertidos/pagamento.txt" , "r")
    Pagamento.delete_all
    clinica = ''
    while line = f.gets 
      begin
        registro = busca_registro(line)
        if clinica != registro.last
          clinica  = registro.last
          @clinica = Clinica.find_by_sigla(clinica)
        end
        t                   = Pagamento.new
        t.clinica_id        = @clinica.id
        @tipo_pagamento     = TipoPagamento.find_by_seq_and_clinica_id(registro[6].to_i,@clinica.id)
        t.tipo_pagamento_id = @tipo_pagamento.id if !@tipo_pagamento.nil?
        t.data_de_pagamento = registro[3].to_date if Date.valid?(registro[3])
        t.sequencial        = registro[6].to_i
        t.valor_pago        = le_valor(registro[2])
        t.observacao        = registro[4]
        t.valor_restante    = le_valor(registro[13]) unless registro[13].blank?
        t.valor_cheque      = le_valor(registro[11]) unless registro[11].blank?
        t.valor_terceiros   = le_valor(registro[10]) unless registro[10].blank?
        t.conta_bancaria_id = registro[14].to_i unless registro[14].to_i == -1 
        t.numero_do_cheque  = registro[15]
        t.nao_lancar_no_livro_caixa = (registro[16].to_i!= 0)
        t.data_de_exclusao          = registro[17].to_date unless registro[17].blank?
        t.save
      rescue Exception => ex
        @arquivo.puts "Erro ao processar a linha #{line}"
      end
    end
    f.close
    fecha_arquivo_de_erros('Pagamentos')
  end
  
  def fluxo_de_caixa
    abre_arquivo_de_erros('Fluxo de caixa')
    # @arquivo = File.open('doc/erros de conversao.txt', 'a')  
    #  @arquivo.puts "Iniciando conversão de Fluxo em #{Time.current}"
 
    puts "Convertendo fluxo de caixa ...."
    f = File.open("doc/convertidos/saldos.txt" , "r")
    FluxoDeCaixa.delete_all
    clinica = ''  
    while line = f.gets 
      begin
        registro = busca_registro(line)
        if clinica != registro[3]
          clinica = registro[3]
          @clinica = Clinica.find_by_sigla(registro[3])
        end
        t = FluxoDeCaixa.new
        t.clinica_id        = @clinica.id
        t.data              = registro[0].to_date
        t.saldo_em_dinheiro = le_valor(registro[1])
        t.saldo_em_cheque   = le_valor(registro[2])
        t.save
      rescue Exception => ex
        @arquivo.puts "Erro ao processar a linha #{line}"
      end
    end
    f.close
    fecha_arquivo_de_erros('Fluxo de caixa')
  end
  
  def cheque
    # depende de destinacao, recebimento, pagamento
    #TODO Os cheques das clíncas existem na administração. Preciso tratar isto
    abre_arquivo_de_erros("Cheques")
    puts "Convertendo cheques ...."
    f = File.open("doc/convertidos/cheque.txt" , "r")
   # Banco.delete_all
    Cheque.delete_all
    #TODO verificar se o cheque está disponível
    clinica = ''
    while line = f.gets 
      begin
        registro = busca_registro(line)
        if clinica != registro.last
          clinica = registro.last
          @clinica = Clinica.find_by_sigla(clinica)
        end
        t                 = Cheque.new
        t.clinica_id      = @clinica.id
        t.sequencial      = registro[0].to_i
        verifica_existencia_do_banco(registro[1].to_i)
        t.banco_id        = Banco.find_by_numero(registro[1].to_i).id
        t.agencia         = registro[2]
        t.conta_corrente  = registro[3]
        t.numero          = registro[4]
        t.bom_para        = registro[5].to_date if Date.valid?(registro[5])
        t.valor           = le_valor(registro[6])
        paciente          = Paciente.find_by_sequencial_and_clinica_id(registro[7].to_i, @clinica.id)
        t.paciente_id     = paciente.id unless paciente.nil?
        t.data            = registro[8].to_date if Date.valid?(registro[8])
        if !registro[10].blank? && registro[9].to_i > 0
          d = Destinacao.find_by_sequencial_and_clinica_id(registro[9].to_i, @clinica.id)
          if !d.nil?
            t.destinacao_id   = d.id 
            t.data_destinacao = registro[10].to_date if Date.valid?(registro[10])
          end
        end
        pagamento                   = Pagamento.find_by_sequencial_and_clinica_id(registro[11].to_i, @clinica.id)
        t.pagamento_id              = pagamento.id if pagamento.present?
        if registro[12] ==  'Verdadeiro'
          t.data_entrega_administracao = registro[13] if Date.valid?(registro[13])
        end
        if registro[14].to_i > 0
          paciente2                 = Paciente.find_by_sequencial_and_clinica_id(registro[14].to_i, @clinica.id)
          t.segundo_paciente        = paciente2.id if paciente2.present?
        end
        if registro[15].to_i > 0
          paciente3                 = Paciente.find_by_sequencial_and_clinica_id(registro[15].to_i, @clinica.id)
          t.terceiro_paciente       = paciente3.id if paciente3.present?
        end
        t.data_primeira_devolucao   = registro[17].to_date if Date.valid?(registro[17])
        t.motivo_primeira_devolucao = registro[18] unless registro[18].blank?
        t.data_lancamento_primeira_devolucao = registro[19].to_date if Date.valid?(registro[19])
        t.data_reapresentacao       = registro[20].to_date if Date.valid?(registro[20])
        t.data_segunda_devolucao    = registro[21].to_date if Date.valid?(registro[21])
        t.motivo_segunda_devolucao  = registro[22]
        t.data_solucao              = registro[23].to_date if Date.valid?(registro[23])
        t.descricao_solucao         = registro[24]
        t.data_caso_perdido         = registro[25]
        t.data_segunda_devolucao    = registro[26] if Date.valid?(registro[26])
        recebimento                 = Recebimento.find_by_sequencial_and_clinica_id(registro[27].to_i, @clinica.id)
        t.recebimento_id            = recebimento.id if recebimento.present?
        t.data_de_exclusao          = registro[28] if Date.valid?(registro[28])
        t.data_arquivo_morto        = registro[29].to_date if Date.valid?(registro[29])
        t.pagamento_id              = nil
        if registro[11].to_i > 0
          pagamento                 = Pagamento.find_by_sequencial_and_clinica_id(registro[11].to_i, @clinica.id)
          t.pagamento_id            = pagamento.id if pagamento.present?
        end
        if registro[12] == 'Verdadeiro'
          t.data_entrega_administracao        = registro[10].to_date if Date.valid?(registro[10])
          t.data_recebimento_na_administracao = registro[10].to_date if Date.valid?(registro[10])
        else
          t.data_recebimento_na_administracao = nil
        end
        t.data_de_exclusao       = registro[28].to_date if Date.valid?(registro[28])
        t.save
        if recebimento.present?
          recebimento.cheque_id  = t.id
          recebimento.observacao = t.banco.nome + " - " + t.numero if !recebimento.observacao.present?
          recebimento.save
        end
      rescue Exception => ex
        @arquivo.puts line + "\n"+ "      ->" + ex
      end
    end
    f.close
    fecha_arquivo_de_erros("Cheques")
  end
  
  def destinacao
    abre_arquivo_de_erros("Destinação")
    puts "Convertendo destinacao ...."
    f = File.open("doc/convertidos/destinacao.txt" , "r")
    Destinacao.delete_all
    clinica = ''
    while line = f.gets 
      begin
        registro = busca_registro(line)
        if clinica != registro.last
          clinica  = registro.last
          @clinica = Clinica.find_by_sigla(clinica)
        end
        t            = Destinacao.new
        t.clinica_id = @clinica.id
        t.sequencial = registro[0].to_i
        t.nome       = registro[1].nome_proprio
        t.save
      rescue Exception => ex
        @arquivo.puts line + "\n"+ "      ->" + ex
      end
    end
    f.close
    fecha_arquivo_de_erros("Destinação")
  end
  
  def orcamento
    abre_arquivo_de_erros("Orçamento")
    puts "Convertendo orçamento ...."
    f = File.open("doc/convertidos/orcamento.txt" , "r")
    Orcamento.delete_all
    clinica    = ''
    while line = f.gets 
      begin
        registro = busca_registro(line)
        if clinica != registro.last
          clinica  = registro.last
          @clinica = Clinica.find_by_sigla(clinica)
        end
        o                             = Orcamento.new
        o.sequencial                  = registro[0].to_i
        o.clinica_id                  = @clinica.id
        o.data                        = registro[1].to_date if Date.valid?(registro[1])
        paciente                      = Paciente.find_by_sequencial_and_clinica_id(registro[2].to_i, @clinica.id)
        o.paciente_id                 = paciente.id if paciente.present?
        dentista                      = Dentista.find_by_sequencial_and_clinica_id(registro[3].to_i, @clinica.id)
        o.dentista_id                 = dentista.id if dentista.present?
        o.numero                      = registro[4]
        o.numero_de_parcelas          = registro[6].to_i
        o.valor_da_parcela            = le_valor(registro[7])
        o.vencimento_primeira_parcela = registro[8].to_date if Date.valid?(registro[8])
        #FIXME traduzir isto aqui para as formas conhecidas
        o.forma_de_pagamento          = 'cheque pre' if registro[9]=='P'
        o.forma_de_pagamento          = 'a vista' if registro[9]=='V'
        o.forma_de_pagamento          = 'cartao' if registro[9]=='C'
        o.data_de_inicio              = registro[10].to_date if  Date.valid?(registro[10])
        o.valor_com_desconto          = le_valor(registro[12])
        o.desconto                    = registro[13].to_i
        o.valor                       = o.valor_com_desconto / (100 - (o.desconto / 100)) * 100
        o.save
      rescue Exception => ex
        @arquivo.puts line + "\n"+ "      ->" + ex
      end
    end
    f.close
    fecha_arquivo_de_erros("Orçamento")
  end
  
  def protetico
    abre_arquivo_de_erros('Protético')
    puts "Convertendo protéticos ...."
    f = File.open("doc/convertidos/protetico.txt" , "r")
    Protetico.delete_all
    clinica = ''
    while line = f.gets 
      begin
        registro = busca_registro(line)
        if clinica  != registro.last
          clinica   = registro.last
          @clinica  = Clinica.find_by_sigla(clinica)
        end
        p              = Protetico.new
        p.sequencial   = registro[0].to_i
        p.clinica_id   = @clinica.id
     #   p.clinicas     << clinica
        p.nome         = registro[1].nome_proprio
        p.logradouro   = registro[2]
        p.bairro       = registro[3]
        p.cidade       = registro[4]
        p.estado       = registro[5]
        p.cep          = registro[6]
        p.telefone     = registro[7]
        p.email        = registro[8]
        p.cpf          = registro[9]
        p.nascimento   = registro[10].to_date if Date.valid?(registro[10])
        p.save
      rescue Exception => ex
        @arquivo.puts line + "\n"+ "      ->" + ex
      end
    end
    f.close 
    fecha_arquivo_de_erros("Orçamento")
  end
  
  def tabela_protetico
    #Tabela base
    abre_arquivo_de_erros('Tabela base de protético')
    puts "Convertendo tabela base de protéticos ...."
    f = File.open("doc/convertidos/tabela_protetico.txt" , "r")
    TabelaProtetico.delete_all
    while line = f.gets 
      begin
        registro = busca_registro(line)
        item     = TabelaProtetico.find_by_descricao(registro[1]) 
        if item.nil?
          t              = TabelaProtetico.new
          t.descricao    = registro[1]
          t.valor        = le_valor(registro[2])
          t.save
        end
      rescue Exception => ex
        @arquivo.puts line + "\n"+ "      ->" + ex
      end
    end
    f.close
    fecha_arquivo_de_erros('Tabela base de protético')
    #
    abre_arquivo_de_erros('Tabela dos protéticos')
    # tabelas dos proteticos
    puts "Convertendo tabela dos protéticos ...."
    f = File.open("doc/convertidos/item_protetico.txt" , "r")
    clinica = ''
    while line = f.gets 
      begin
      registro = busca_registro(line)
        if clinica != registro.last
          clinica  = registro.last
          @clinica = Clinica.find_by_sigla(clinica)
        end
        t                = TabelaProtetico.new
        t.sequencial     = registro[0].to_i
        protetico        = Protetico.find_by_sequencial_and_clinica_id(registro[1].to_i, @clinica.id)
        if protetico.present?
          t.protetico_id = protetico.id
        end
        t.descricao      = registro[2]
        t.valor          = le_valor(registro[3])
        t.save
      rescue Exception => ex 
        @arquivo.puts line + "\n"+ "      ->" + ex
      end
    end
    f.close
    fecha_arquivo_de_erros('Tabela de protético')
  end
  
  def trabalho_protetico
    # depende de orçamento
    abre_arquivo_de_erros('Trabalho protético')
    puts "Convertendo trabalho protético ...."
    f = File.open("doc/convertidos/noprotetico.txt" , "r")
    TrabalhoProtetico.delete_all
    clinica = ''
    while line = f.gets 
      begin
        registro = busca_registro(line)
        if clinica != registro.last
          clinica  = registro.last
          @clinica = Clinica.find_by_sigla(clinica)
        end
        t                       = TrabalhoProtetico.new
        t.clinica_id            = @clinica.id
        dentista                = Dentista.find_by_sequencial_and_clinica_id(registro[10].to_i, @clinica.id)
        t.dentista_id           = dentista.id unless dentista.nil?
        protetico               = Protetico.find_by_sequencial_and_clinica_id(registro[0].to_i, @clinica.id)
        t.protetico_id          = protetico.id unless protetico.nil?
        paciente                = Paciente.find_by_sequencial_and_clinica_id(registro[1].to_i, @clinica.id)
        t.paciente_id           = paciente.id unless paciente.nil?
        t.dente                 = registro[6]
          t.data_de_envio                           = registro[3].to_date if Date.valid?(registro[3])
          t.data_prevista_de_devolucao              = registro[5].to_date if Date.valid?(registro[5])
          t.data_de_devolucao                       = registro[4].to_date if Date.valid?(registro[4])
          t.data_de_repeticao                       = registro[12].to_date if Date.valid?(registro[12])
          t.data_prevista_da_devolucao_da_repeticao = registro[15].to_date if Date.valid?(registro[15])
        tabela                = TabelaProtetico.find_by_protetico_id_and_sequencial(protetico.id,registro[8].to_i)
        t.tabela_protetico    = tabela unless tabela.nil?
        t.valor               = le_valor(registro[7]) unless registro[7].nil?
        t.cor                 = registro[11]
        t.observacoes         = registro[9]
        t.motivo_da_repeticao = registro[13]
        t.pagamento_id        = 0
        #FIXME definir como registrar que foi pago
        t.save
      rescue Exception => ex 
        @arquivo.puts line + "\n"+ "      ->" + ex
      end
    end
    f.close
    fecha_arquivo_de_erros('Tabela de protético')
  end
  
  def alta
    puts "Convertendo altas ...."
    Paciente.all.each do |p|  
      begin
        t = Tratamento.all(:conditions=>['paciente_id = ? and data IS NULL', p])
        if t.empty?
          ultimo          = Tratamento.last(:conditions=>['paciente_id = ? and data IS NOT NULL', p], :order=>'data desc')
          alta            = Alta.new
          alta.clinica_id = p.clinica_id
          #FIXME fazer para todas as clínicas
          alta.paciente   = p
          if ultimo.nil?
            alta.data_inicio = Date.today
          else
            alta.data_inicio = ultimo.data
          end
          alta.observacao  = 'gerada pela conversão'
          alta.user_id     = 1
          alta.save
        end
      rescue
        @arquivo.puts p.nome + "\n"+ "      ->" + ex
      end
    end
    f.close
    fecha_arquivo_de_erros('Tabela de protético')
  end
  
  
  private
  
  def verifica_existencia_do_banco(numero)
    b  = Banco.find_by_numero(numero)
    if b.nil?
      Banco.create(:numero=>numero, :nome=>numero)
    end
  end
  
  def le_valor(val)
    return 0 if val.nil? || val.blank?
    #aux = val.split(" ")[1]
    #return 0 if aux.nil?
    aux = val.sub(".","")
    aux = val.sub(",",".")
    return aux
  end
  
  def busca_registro(line)
    line.split('"')[1].split(";")
  end

  def abre_arquivo_de_erros(mensagem)
    @arquivo = File.open('doc/erros de conversao.txt', 'a')  
    @arquivo.puts '                '
    @arquivo.puts "Iniciando conversão de #{mensagem} em #{Time.current}"
  end
  
  def fecha_arquivo_de_erros(mensagem)
    @arquivo.puts "Terminando conversão de #{mensagem} em #{Time.current}"
    @arquivo.puts '                '
    @arquivo.close
  end
end