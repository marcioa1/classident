class Converte
  
  require 'fastercsv'
  
  CLINICAS = Hash.new
  
  def clinicas
    todas = Clinica.all
    todas.each() do |cli|
      CLINICAS[cli.sigla]  = cli.id
      cli.dentistas = []
      cli.save
    end
  end  

  def cadastro 
    abre_arquivo_de_erros('Cadastro')
    puts "Convertendo cadastro ..."

    tabela_inexistente = Tabela.find_by_nome('Inexistente')
    Paciente.delete_all
    FasterCSV.foreach('doc/convertidos/cadastro.txt', option={:col_sep=>';'}) do |registro|
      begin
        clinica_index           = CLINICAS[registro.last] * 100000
        p                       = Paciente.new
        p.codigo                = registro[1].to_i
        if registro[0].upcase.include?('ORTO')
          index                 = registro[0].upcase.index('ORTO')
          p.nome                = registro[0][0..index-1].nome_proprio
          p.ortodontia          = true
        else
          p.nome                = registro[0].nome_proprio
          p.ortodontia          = false
        end
        p.sequencial            = registro[1].to_i
        tabela_id               = @@tabelas[clinica_index + registro[2].to_i] #Tabela.find_by_sequencial_and_clinica_id(registro[2].to_i, @clinica.id)
        if tabela_id.nil?
          p.tabela_id           = tabela_inexistente.id
        else
          p.tabela_id           = tabela_id 
        end
        p.clinica_id            = CLINICAS[registro.last]
        p.cpf                   = registro[16]
        p.profissao             = registro[8]
        p.indicado_por          = registro[15]
        p.sexo                  = registro[6].to_i == 0 ? "M" : "F"
        p.inicio_tratamento     = registro[7].to_date unless !Date.valid?(registro[7])
        p.sair_da_lista_de_debitos          = registro[29]
        p.motivo_sair_da_lista_de_debitos   = registro[30]
        p.data_da_saida_da_lista_de_debitos = registro[31].to_date unless !Date.valid?(registro[31])

        if registro[34].to_i  > 0
          ortodontista = @@dentistas[clinica_index + registro[34].to_i]
          p.ortodontia = true
          p.ortodontista_id = ortodontista if ortodontista
          p.mensalidade_de_ortodontia = le_valor(registro[33])
        else
          p.ortodontia = false
        end
        if !p.save
          puts 'Cadastro : ' + p.errors.full_messages
        end
      rescue Exception => ex
        @arquivo.puts registro.join(';') + "\n"+ "      ->" + ex 
      end
    end
    fecha_arquivo_de_erros('Cadastro')
  end
  
  def mala_direta
    #FIXME considerar que pode haver outras pessoas que não sejam pacientes
    abre_arquivo_de_erros('Mala-direta')
    puts "Convertendo mala direta ..."
    FasterCSV.foreach('doc/convertidos/maladireta.txt', option={:col_sep=>';'}) do |registro|
      begin
        clinica_id = CLINICAS[registro.last]
        if registro[0].upcase.include?('ORTO')
          index    = registro[0].upcase.index('ORTO')
          nome     = registro[0][0..index-1].nome_proprio
        else
          nome     = registro[0].nome_proprio
        end
        p = Paciente.find_by_nome_and_clinica_id(nome, clinica_id)
        if p.present?
          p.logradouro   = registro[3]
          p.bairro       = registro[4]
          p.cidade       = registro[5]
          p.nascimento   = registro[6].to_date if Date.valid?(registro[6])
          p.uf           = registro[7]
          p.cep          = registro[8][0..7] if registro[8]
          p.telefone     = registro[9]
          p.email        = registro[15]
          if !p.save
            puts "Erro #{p.errors.full_messages}"
          end
        else
          puts "Não encontrou  "+ nome + '/'+ clinica_id.to_s
        end
      rescue Exception => ex
        @arquivo.puts registro.join(';') + "\n"+ "      ->" + ex
      end
    end
    fecha_arquivo_de_erros('Mala-direta')
  end
  
  def debito
    # Depende de tratamento
    abre_arquivo_de_erros('Débitos')
    puts "Convertendo débitos ....#{Time.current}"
    Debito.delete_all
    clinica = ''
    FasterCSV.foreach('doc/convertidos/debito.txt', option={:col_sep=>';'}) do |registro|
      begin
        if clinica != registro.last
          clinica       = registro.last
          @clinica      = Clinica.find_by_sigla(clinica)
          clinica_index = @clinica.id * 100000
        end
        d               = Debito.new
        paciente        = @@pacientes[clinica_index + registro[0].to_i]
        d.paciente_id   = paciente unless paciente.nil?
        d.data          = registro[1].to_date
        d.valor         = le_valor(registro[2])
        d.descricao     = registro[3].tira_acento
        d.tratamento_id = registro[10].to_i
        d.clinica_id    = @clinica.id
        d.save!
      rescue Exception => ex
        @arquivo.puts registro.join(';') + "\n"+ "      ->" + ex
      end
    end
    fecha_arquivo_de_erros('Débitos')
  end
  
  def formas_recebimento
    abre_arquivo_de_erros('Formas de recebimento')
    puts "Convertendo formas de recebimentos ...."
    FormasRecebimento.delete_all
    FormaRecebimentoTemp.delete_all
    clinica = ''
    FasterCSV.foreach('doc/convertidos/formarec.txt', option={:col_sep=>';'}) do |registro|
      begin
        if clinica != registro.last
          clinica = registro.last
          @clinica = Clinica.find_by_sigla(clinica)
        end
        forma_adm = FormasRecebimento.find_by_nome(registro[0].strip)
        if forma_adm.nil?
          forma_adm = FormasRecebimento.new
          forma_adm.nome = registro[0].strip
          case forma_adm.nome.downcase
            when 'dinheiro' 
              forma_adm.tipo = 'D'
            when 'cheque'
              forma_adm.tipo = 'C'
            else 
              forma_adm.tipo = 'O'
          end
          forma_adm.save
        end
        forma_cli            = FormaRecebimentoTemp.new
        forma_cli.seq        = registro[1].to_i
        forma_cli.id_adm     = forma_adm.id
        forma_cli.clinica_id = @clinica.id
        forma_cli.save
      rescue Exception => ex
        @arquivo.puts registro.join(';') + "\n"+ "      ->" + ex
      end
    end
    fecha_arquivo_de_erros('Formas de recebimento')
  end
  
  def recebimento
    abre_arquivo_de_erros("Recebimentos")
    puts "Convertendo recebimentos ...."
    Recebimento.delete_all
    clinica = ''
    FasterCSV.foreach('doc/convertidos/recebimento.txt', option={:col_sep=>';'}) do |registro|
      begin
        if clinica != registro.last
          clinica  = registro.last
          @clinica = Clinica.find_by_sigla(clinica)
          clinica_index = @clinica.id * 100000
        end
        r                       = Recebimento.new
        r.data                  = registro[1].to_date
        paciente                = @@pacientes[clinica_index + registro[2].to_i]
        if paciente.nil?
          @arquivo.puts "Paciente não encontrado em recebimento: id #{registro[2]}, clínica : #{@clinica.id}"
          @arquivo.puts registro.join(';')
        else
          r.paciente_id         = paciente
        end
        forma_recebimento       = FormaRecebimentoTemp.find_by_seq_and_clinica_id(registro[3].to_i, @clinica.id)
        if forma_recebimento.nil?
          @arquivo.puts "Forma de recebimento não encontrada em recebimento: id #{registro[3]}, clínica : #{@clinica.id}"
          @arquivo.puts registro.join(';')
        else
          r.formas_recebimento_id = forma_recebimento.id_adm 
        end
        r.valor                 = le_valor(registro[4])
        r.observacao            = registro[7].tira_acento
        r.sequencial            = registro[8].to_i
        r.clinica_id            = @clinica.id
        r.percentual_dentista   = registro[11].to_i
        r.data_de_exclusao      = registro[12].to_date if Date.valid?(registro[12])
        r.observacao_exclusao   = registro[14]
        #FIXME Verificar qual o campo de cheque_id
        # r.cheque_id             = registro[0].to_i if !registro[0].blank?
        r.save
      rescue Exception => ex
        @arquivo.puts registro.join(';') + "\n"+ "      ->" + ex
      end
    end
    fecha_arquivo_de_erros('Recebimento')
  end
  
  def tabela
    abre_arquivo_de_erros('Tabelas ....')
    puts "Convertendo tabelas ....#{Time.current}"
    Tabela.delete_all
    Tabela.create!(:nome => 'Inexistente', :clinica_id=>0, :ativa => false, :sequencial=>1)

    clinica = ''
    FasterCSV.foreach('doc/convertidos/tabela_nova.txt', option={:col_sep=>';'}) do |registro|
      begin
        if clinica != registro.last
          clinica = registro.last
          @clinica = Clinica.find_by_sigla(clinica)
        end
        t              = Tabela.new
        t.sequencial   = registro[0].to_i
        t.nome         = registro[1].nome_proprio
        t.ativa        = ['Verdadeiro', 'True', 1].include?(registro[5])
        t.clinica_id   = @clinica.id
        t.save
      rescue Exception => ex
        puts registro.join(';') + "\n"+ "      ->" + ex
      end
    end
    fecha_arquivo_de_erros('Tabelas')
  end
       
       
  def item_tabela
    abre_arquivo_de_erros('Item tabelas ...')
    puts "Convertendo item das tabelas ...."
    ItemTabela.delete_all
    Preco.delete_all
    clinica = ''
    FasterCSV.foreach('doc/convertidos/item_tabela.txt', option={:col_sep=>';'}) do |registro|
      begin
        if clinica != registro.last
          clinica = registro.last
          @clinica = Clinica.find_by_sigla(clinica)
        end
        tabela = Tabela.find_by_sequencial_and_clinica_id(registro[1].to_i,@clinica.id)
        if tabela
          t            = ItemTabela.new
          t.sequencial = registro[0].to_i
          t.clinica_id = @clinica.id
          t.tabela_id  = tabela.id
          t.codigo     = registro[2]
          t.descricao  = registro[3]
          t.preco      = le_valor(registro[4])
          t.save
          # Preco.create(:item_tabela_id=> t.id, :clinica_id=>@clinica.id, :preco=> valor)
        end
      rescue Exception => ex
        @arquivo.puts registro.join(';') + "\n"+ "      ->" + ex
          @arquivo.puts t.errors.full_message
      end
    end
    fecha_arquivo_de_erros('Item Tabela')
  end
  
  def odontograma
    # depende de dentista
    abre_arquivo_de_erros('Odontograma')
    puts "Convertendo odontograma ...."
    itens_das_tabelas = Array.new
    ItemTabela.all.each do |it|
      itens_das_tabelas[it.clinica_id * 100000 + it.sequencial] = it.id
    end
    Tratamento.delete_all
    clinica = ''
    FasterCSV.foreach('doc/convertidos/odontograma.txt', option={:col_sep=>';'}) do |registro|
      begin
        clinica_index     = CLINICAS[registro.last] * 100000
        t                 = Tratamento.new
        t.sequencial      = registro[0].to_i
        paciente          = @@pacientes[clinica_index + registro[2].to_i]
        if paciente
          t.paciente_id     = paciente
          if registro[9].to_i > 0
            item_tabela       = itens_das_tabelas[clinica_index + registro[9].to_i]
            t.item_tabela_id  = item_tabela if item_tabela.present?
          end
          if !registro[1].blank?
            dentista       = @@dentistas[clinica_index + registro[1].to_i]
            t.dentista_id  = dentista 
          end
          t.valor          = le_valor(registro[6])
          t.data           = registro[7].to_date if Date.valid?(registro[7])
          t.dente          = registro[3]
          t.face           = registro[4]
          t.descricao      = registro[5]
          if registro[8].to_i > 0
            orcamento      = Orcamento.find_by_numero_and_paciente_id_and_clinica_id(registro[8].to_i, paciente, @clinica.id,
               :select=>'data_de_inicio')
            if orcamento && orcamento.em_aberto? && t.data.present?
              orcamento.update_attribute(:data_de_inicio , t.data)
              # orcamento.data_de_inicio = t.data
              # orcamento.save
            end
            t.orcamento_id   = orcamento.id if orcamento.present?
          end
          t.custo          = le_valor(registro[12])
          t.excluido       = ['Verdadeiro', 'True'].include?(registro[16])
          t.clinica_id     = CLINICAS[registro.last]
          t.created_at     = registro[14].to_date if Date.valid?(registro[14])
          t.save
        end
        rescue Exception => ex
          @arquivo.puts registro.join(';') + "\n"+ "      ->" + ex
        end
    end
    fecha_arquivo_de_erros('odontograma')
  end
  
  def dentista
    abre_arquivo_de_erros('Dentistas')
    puts "Convertendo dentistas ....#{Time.current}"
    Dentista.delete_all
    clinica = ''
    FasterCSV.foreach('doc/convertidos/dentista.txt', option={:col_sep=>';'}) do |registro|
      begin
        # if clinica != registro.last
        #           @clinica.save if !clinica.blank?
        #           clinica  = registro.last
        #           @clinica = Clinica.find_by_sigla(clinica)
        #         end
        clinica_id               = CLINICAS[registro.last] 
        dentista                 = Dentista.new
        dentista.sequencial      = registro[0].to_i
        dentista.clinica_id      = clinica_id
        dentista.nome            = registro[1].strip.nome_proprio if registro[1]
        dentista.cro             = registro[2].strip if registro[2]
        dentista.cro             = '?' if dentista.cro.blank?
        dentista.ativo           = registro[5] == 'True'
        dentista.percentual      = registro[4].sub(",",".") unless registro[4].blank? or registro[4].nil?
        dentista.especialidade   = registro[3]
        dentista.save
        @clinica.dentistas << dentista
      rescue Exception => ex
        @arquivo.puts registro.join(';') + "\n"+ "      ->" + ex
      end
    end
    @clinica.save if @clinica
    fecha_arquivo_de_erros('Dentistas')
  end
  
  def tipo_pagamento
    abre_arquivo_de_erros('Tipo de Pagamento')
    puts "Convertendo tipos de pagamentos ...."
    TipoPagamento.delete_all
    clinica = ''
    FasterCSV.foreach('doc/convertidos/tipo_pagamento.txt', option={:col_sep=>';'}) do |registro|
      begin
        if clinica != registro.last
          clinica  = registro.last
          @clinica = Clinica.find_by_sigla(clinica)
        end
        t            = TipoPagamento.new
        t.seq        = registro[0].to_i
        t.nome       = registro[1].nome_proprio
        t.ativo      = ['Verdadeiro','True'].include?(registro[2]) 
        t.clinica_id = @clinica.id
        t.save
      rescue Exception => ex
        @arquivo.puts registro.join(';') + "\n"+ "      ->" + ex
      end
    end
    fecha_arquivo_de_erros('Tipo de Pagamento')
  end
  
  def pagamento
    abre_arquivo_de_erros('Pagamentos')
    puts 'Convertendo pagamentos ... '
    Pagamento.delete_all
    clinica = ''
    FasterCSV.foreach('doc/convertidos/pagamento.txt', option={:col_sep=>';'}) do |registro|
      begin
        if clinica != registro.last
          clinica  = registro.last
          @clinica = Clinica.find_by_sigla(clinica)
        end
        t                   = Pagamento.new
        t.clinica_id        = @clinica.id
        tipo_pagamento      = TipoPagamento.find_by_seq_and_clinica_id(registro[1].to_i,@clinica.id, :select=>['id'])
        t.tipo_pagamento_id = tipo_pagamento.id if tipo_pagamento
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
    fecha_arquivo_de_erros('Pagamentos')
  end
  
  def fluxo_de_caixa
    abre_arquivo_de_erros('Fluxo de caixa')
    # @arquivo = File.open('doc/erros de conversao.txt', 'a')  
    #  @arquivo.puts "Iniciando conversão de Fluxo em #{Time.current}"
 
    puts "Convertendo fluxo de caixa ...."

    FluxoDeCaixa.delete_all
    clinica = ''  
    FasterCSV.foreach('doc/convertidos/saldos.txt', option={:col_sep=>';'}) do |registro|
      begin
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
    fecha_arquivo_de_erros('Fluxo de caixa')
  end
  
  def cheque
    # depende de destinacao, recebimento, pagamento
    abre_arquivo_de_erros("Cheques")
    puts "Convertendo cheques ...."
    Cheque.delete_all
    clinica = ''
    @dest   = Destinacao.all
    um_paciente    = 0
    dois_pacientes = 0
    tres_pacientes = 0
    FasterCSV.foreach('doc/convertidos/cheque.txt', option={:col_sep=>';'}) do |registro|
      begin
        if clinica != registro.last
          clinica = registro.last
          @clinica = Clinica.find_by_sigla(clinica)
          clinica_index = @clinica.id * 100000
        end
        t                 = Cheque.new
        t.clinica_id      = @clinica.id
        t.sequencial      = registro[0].to_i
        verifica_existencia_do_banco(registro[1].to_i)
        t.banco_id        = Banco.find_by_numero(registro[1].to_i).id
        t.agencia         = registro[2]
        t.conta_corrente  = registro[3]
        t.numero          = registro[4]
        t.data            = registro[8].to_date if Date.valid?(registro[8])
        
        if Date.valid?(registro[5])
          t.bom_para      = registro[5].to_date 
        else
          t.bom_para      = t.data
        end
        t.valor           = le_valor(registro[6])
       
        if !registro[9].blank? && registro[9].to_i > 0
          d = @dest.find{|de| de.sequencial == registro[9].to_i && de.clinica_id == @clinica.id }
          if !d.nil?
            t.destinacao_id   = d.id 
            t.data_destinacao = registro[10].to_date if Date.valid?(registro[10])
          end
        end
        pagamento             = Pagamento.find_by_sequencial_and_clinica_id(registro[11].to_i, @clinica.id,
            :select=>'id')
        t.pagamento_id        = pagamento.id if pagamento.present?
        if ['Verdadeiro', 'True', '1'].include?(registro[12])
          if Date.valid?(registro[13])
            t.data_entrega_administracao        = registro[13].to_date 
            t.data_recebimento_na_administracao = t.data_entrega_administracao
          end
        end
        if registro[14].to_i > 0
          paciente2      = @@pacientes[clinica_index + registro[14].to_i]
          dois_pacientes += 1
        else
          um_paciente += 1
        end
        if registro[15].to_i > 0
          paciente3                 = @@pacientes[clinica_index + registro[15].to_i]
          tres_pacientes += 1
          dois_pacientes -= 1
        end
        if Date.valid?(registro[17])
          t.data_primeira_devolucao   = registro[17].to_date 
          t.motivo_primeira_devolucao = registro[18] 
          t.data_lancamento_primeira_devolucao = registro[19].to_date if Date.valid?(registro[19])
          t.data_reapresentacao       = registro[20].to_date if t.data_primeira_devolucao && Date.valid?(registro[20])
          t.data_segunda_devolucao    = registro[21].to_date if t.data_primeira_devolucao && Date.valid?(registro[21])
          t.motivo_segunda_devolucao  = registro[22]
          t.data_solucao              = registro[23].to_date if t.data_primeira_devolucao && Date.valid?(registro[23])
          t.descricao_solucao         = registro[24]
          t.data_caso_perdido         = registro[25]
          t.data_arquivo_morto        = registro[29].to_date if Date.valid?(registro[29])
        end
        # t.recebimento_id            = recebimento.id if recebimento.present?
        t.data_de_exclusao          = registro[28] if Date.valid?(registro[28])
        t.save
        recebimento                 = Recebimento.find_by_sequencial_and_clinica_id(registro[27].to_i, @clinica.id,
                                      :select=>'id,cheque_id')
        recebimento.update_attribute(:cheque_id , t.id) if recebimento
        if paciente2
          recebimento = Recebimento.find_by_sequencial_and_clinica_id(paciente2.to_i, @clinica.id,           
                        :select=>'id,cheque_id')
          recebimento.update_attribute(:cheque_id,  t.id) if recebimento
        end
        if paciente3
          recebimento = Recebimento.find_by_sequencial_and_clinica_id(paciente3.to_i, @clinica.id,           
                        :select=>'id,cheque_id')
          recebimento.update_attribute(:cheque_id,  t.id) if recebimento
        end
      rescue Exception => ex
        @arquivo.puts registro.join(';') + "\n"+ "      ->" + ex
      end
    end
    @arquivo.puts "Cheques para um paciente : " + um_paciente.to_s
    @arquivo.puts "Cheques para dois pacientes : " + dois_pacientes.to_s
    fecha_arquivo_de_erros("Cheques")
  end
  
  def destinacao
    abre_arquivo_de_erros("Destinação")
    puts "Convertendo destinacao ...."
    Destinacao.delete_all
    clinica = ''
    FasterCSV.foreach('doc/convertidos/destinacao.txt', option={:col_sep=>';'}) do |registro|
      begin
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
        @arquivo.puts registro.join(';') + "\n"+ "      ->" + ex
      end
    end
    fecha_arquivo_de_erros("Destinação")
  end
  
  def orcamento
    abre_arquivo_de_erros("Orçamento")
    puts "Convertendo orçamento ...."
    Orcamento.delete_all
    ct_erros   = 1
    FasterCSV.foreach('doc/convertidos/orcamento.txt', option={:col_sep=>';'}) do |registro|
      begin
        clinica_index = CLINICAS[registro.last] * 100000
        o                             = Orcamento.new
        o.sequencial                  = registro[0].to_i
        o.clinica_id                  = CLINICAS[registro.last] 
        o.data                        = registro[1].to_date if Date.valid?(registro[1])
        paciente                      = @@pacientes[clinica_index + registro[2].to_i]
        if paciente
          o.paciente_id               = paciente
          dentista                      = @@dentistas[clinica_index + registro[3].to_i]
          o.dentista_id                 = dentista if !dentista.nil?
          o.numero                      = registro[4].to_i
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
        else
          @arquivo.puts ct_erros
          @arquivo.puts "Orcamento #{registro[0]} sem paciente #{registro[2]} na clínica #{@clinica.id}"          
          @arquivo.puts registro.join(';')
          ct_erros += 1 
        end
      rescue Exception => ex
        @arquivo.puts registro.join(';') + "\n"+ "      ->" + ex
      end
    end
    fecha_arquivo_de_erros("Orçamento")
  end
  
  def protetico
    abre_arquivo_de_erros('Protético')
    puts "Convertendo protéticos ...."
    Protetico.delete_all
    clinica = ''
    FasterCSV.foreach('doc/convertidos/protetico.txt', option={:col_sep=>';'}) do |registro|
      begin
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
        @arquivo.puts registro.join(';') + "\n"+ "      ->" + ex
      end
    end
    fecha_arquivo_de_erros("Protéticos")
  end
  
  def tabela_protetico
    #Tabela base
    abre_arquivo_de_erros('Tabela base de protético')
    puts "Convertendo tabela base de protéticos ...."
    TabelaProtetico.delete_all
    FasterCSV.foreach('doc/convertidos/tabela_protetico.txt', option={:col_sep=>';'}) do |registro|
      begin
        item     = TabelaProtetico.find_by_descricao(registro[1]) 
        if item.nil?
          t              = TabelaProtetico.new
          t.descricao    = registro[1]
          t.valor        = le_valor(registro[2])
          t.save
        end
      rescue Exception => ex
        @arquivo.puts registro.join(';') + "\n"+ "      ->" + ex
      end
    end
    fecha_arquivo_de_erros('Tabela base de protético')
    #
    abre_arquivo_de_erros('Tabela dos protéticos')
    # tabelas dos proteticos
    puts "Convertendo tabela dos protéticos ...."
    clinica = ''
    FasterCSV.foreach('doc/convertidos/item_protetico.txt', option={:col_sep=>';'}) do |registro|
      begin
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
        @arquivo.puts registro.join(';') + "\n"+ "      ->" + ex
      end
    end
    fecha_arquivo_de_erros('Tabela de protético')
  end
  
  def trabalho_protetico
    # depende de orçamento
    abre_arquivo_de_erros('Trabalho protético')
    puts "Convertendo trabalho protético ...."
    TrabalhoProtetico.delete_all
    clinica = ''
    FasterCSV.foreach('doc/convertidos/noprotetico.txt', option={:col_sep=>';'}) do |registro|
      begin
        if clinica != registro.last
          clinica  = registro.last
          @clinica = Clinica.find_by_sigla(clinica)
          clinica_index = @clinica.id * 100000
        end
        t                       = TrabalhoProtetico.new
        t.clinica_id            = @clinica.id
        dentista                = @@dentistas[clinica_index + registro[0].to_i]
        t.dentista_id           = dentista unless dentista.nil?
        protetico               = Protetico.find_by_sequencial_and_clinica_id(registro[0].to_i, @clinica.id)
        t.protetico_id          = protetico.id unless protetico.nil?
        paciente                = @@pacientes[clinica_index + registro[1].to_i]
        t.paciente_id           = paciente unless paciente.nil?
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
        @arquivo.puts registro.join(';') + "\n"+ "      ->" + ex
      end
    end
    fecha_arquivo_de_erros('Tabela de protético')
  end
  
  def alta
    abre_arquivo_de_erros('Alta')
    puts "Convertendo altas ...."
    Paciente.all.each do |p|  
      begin
        t = p.tratamentos.find_all{ |t| t.data==nil}
        if t.empty?
          ultimo          = p.tratamenos.last     #Tratamento.last(:conditions=>['paciente_id = ? and data IS NOT NULL', p], :order=>'data desc')
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
      rescue Exception => ex
        @arquivo.puts p.nome + "\n"+ "      ->" + ex
      end
    end
    fecha_arquivo_de_erros('Tabela de protético')
  end
  
  def adm_cheques
    abre_arquivo_de_erros('Cheques na Administação')
    puts "Convertendo cheques na administração ...."
    @as_clinicas = Clinica.all
    @siglas      = @as_clinicas.map(&:sigla)
    @clinica = Clinica.administracao.first
    ct       = 0
    FasterCSV.foreach('doc/convertidos/adm_cheque.txt', option={:col_sep=>';'}) do |registro|
      begin
        ct += 1
        if @siglas.include?(registro[1].downcase)
          clinica                  = @as_clinicas.find{ |cl| cl.sigla == registro[1].downcase}
          seq                      = registro[2]
          destinacao               = Destinacao.first #registro[11]
          #FIXME tratar a destinacao na adm
          data_destinacao          = registro[12].to_date if Date.valid?(registro[12])
          pagamento                = registro[13].to_i 
          devolvido                = registro[16]
          if Date.valid?(registro[17])
            data_devolucao           = registro[17].to_date 
            motivo_devolucao         = registro[18]
            data_reapresentacao      = registro[19].to_date if Date.valid?(registro[19])
            data_segunda_devolucao   = registro[20].to_date if Date.valid?(registro[20])
            motivo_segunda_devolucao = registro[21]
            data_solucao             = registro[22].to_date if Date.valid?(registro[22])
            solucao                  = registro[23]
            data_caso_perdido        = registro[24].to_date if Date.valid?(registro[24])
          end
          historico                = registro[25]
          adm                      = registro[26]
          cheque                   = Cheque.find_by_clinica_id_and_sequencial(clinica.id, seq)
          if cheque && cheque.entregue_a_administracao
            cheque.destinacao               = destinacao
            cheque.data_destinacao          = data_destinacao
            if pagamento > 0
              #FIXME Procurar cheque ref pgto valor 3582.51
              reg_pagamento = Pagamento.find_by_clinica_id_and_sequencial(clinica.id, pagamento)
              cheque.pagamento_id = reg_pagamento.id if reg_pagamento.present?
            end
            # cheque.devolvido              = devolvido
            cheque.data_primeira_devolucao   = data_devolucao
            cheque.motivo_primeira_devolucao = motivo_devolucao
            cheque.data_reapresentacao      = data_reapresentacao
            cheque.motivo_segunda_devolucao = motivo_segunda_devolucao 
            cheque.data_solucao             = data_solucao  
            cheque.descricao_solucao        = solucao
            cheque.data_caso_perdido        = data_caso_perdido
            #FIXME verificar que campo historico é este
            # cheque.historico                = historico
            cheque.data_recebimento_na_administracao = cheque.data_entrega_administracao
            cheque.save  
          end
        end
      rescue Exception => ex
        @arquivo.puts ct.to_s + '->' + registro.join(',') + "\n"+ "      ->" + ex
      end
    end
    fecha_arquivo_de_erros('Cheques Administração')   
  end
  
  def adm_pagamento
    abre_arquivo_de_erros('Pagamentos na administração')
    puts 'Convertendo pagamentos na administração ... '
    @clinica = Clinica.administracao.first
    FasterCSV.foreach('doc/convertidos/adm_pagamento.txt', option={:col_sep=>';'}) do |registro|
      begin
        t                   = Pagamento.new
        t.clinica_id        = @clinica.id
        tipo_pagamento      = TipoPagamento.find_by_seq_and_clinica_id(registro[1].to_i,@clinica.id)
        t.tipo_pagamento_id = tipo_pagamento.id if tipo_pagamento
        t.data_de_pagamento = registro[3].to_date if Date.valid?(registro[3])
        t.sequencial        = registro[6].to_i
        t.opcao_restante    = registro[9]
        t.valor_pago        = le_valor(registro[11])
        t.observacao        = registro[4].gsub('"', '') unless registro[4].blank?
        t.valor_restante    = le_valor(registro[13]) unless registro[13].blank?
        t.valor_cheque      = le_valor(registro[10]) unless registro[10].blank?
        t.valor_terceiros   = le_valor(registro[15]) unless registro[15].blank?
        t.conta_bancaria_id = registro[12].to_i unless registro[12].to_i == -1 
        t.numero_do_cheque  = registro[14]
        t.nao_lancar_no_livro_caixa = (registro[16].to_i!= 0)
        t.data_de_exclusao          = registro[17].to_date unless registro[17].blank?
        t.save
      rescue Exception => ex
        @arquivo.puts "Erro ao processar a linha #{line}"
      end
    end
    fecha_arquivo_de_erros('Pagamentos na administração')
  end
  
  def adm_tipo_pagamento
    abre_arquivo_de_erros('Tipo de Pagamento na Administração')
    puts "Convertendo tipos de pagamentos na administração ...."
    @clinica = Clinica.administracao.first
    FasterCSV.foreach('doc/convertidos/adm_tipo_pagamento.txt', option={:col_sep=>';'}) do |registro|
      begin
        t            = TipoPagamento.new
        t.seq        = registro[0].to_i
        t.nome       = registro[1].nome_proprio
        t.ativo      = ['Verdadeiro','True', '1'].include?(registro[2]) 
        t.clinica_id = @clinica.id
        t.save
      rescue Exception => ex
        @arquivo.puts registro.join(';') + "\n"+ "      ->" + ex
      end
    end
    fecha_arquivo_de_erros('Tipo de Pagamento Administração')
  end
  
  def adm_fluxo
    abre_arquivo_de_erros('Fluxo de Caixa Administação')
    puts "Convertendo fluxo de caixa na administração ...."
    @clinica = Clinica.administracao.first
    FasterCSV.foreach('doc/convertidos/adm_saldos.txt', option={:col_sep=>';'}) do |registro|
      begin
        t                   = FluxoDeCaixa.new
        t.clinica_id        = @clinica.id
        t.data              = registro[0].to_date
        t.saldo_em_dinheiro = le_valor(registro[1])
        t.saldo_em_cheque   = le_valor(registro[2])
        t.save
      rescue Exception => ex
        @arquivo.puts registro.join(';') + "\n"+ "      ->" + ex
      end
    end
    fecha_arquivo_de_erros('Fluxo de Caixa Administração')
  end
  
  def inicia_arquivos_na_memoria
    inicia_pacientes_em_memoria
    inicia_dentistas_em_memoria
    inicia_tabelas_em_memoria
  end

  def inicia_pacientes_em_memoria
    @@pacientes = Array.new
    Paciente.all(:select=> ['id, sequencial, clinica_id']).each do |pa|
       pa.sequencial && @@pacientes[pa.clinica_id * 100000 + pa.sequencial] = pa.id
    end
  end  

  def inicia_dentistas_em_memoria
    @@dentistas = Array.new
    Dentista.all(:select=> ['id, sequencial, clinica_id']).each do |de|
      @@dentistas[de.clinica_id * 100000 + de.sequencial] = de.id
    end
  end 
  
  def inicia_tabelas_em_memoria
    @@tabelas = Array.new
    Tabela.all(:select=>['id,sequencial,clinica_id']).each do |t|
      @@tabelas[t.clinica_id * 100000 + t.sequencial] = t.id
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
    return 0 if val.nil? || val.blank?
    if val.at(0) == 'R'
      val = val.split(' ')[1]
    end
    return 0 if val.nil? || val.blank?
    aux = val.sub(".","")
    aux = val.sub(",",".")
    return aux
  end
  
  # def busca_registro(line)
  #    # @ct += 1
  #    if line[0..0]=='"'
  #      line.split('"')[1].split(";")
  #    else
  #      line.split(";")
  #    end
  #  end

  def abre_arquivo_de_erros(mensagem)
    @arquivo = File.open('doc/erros de conversao.txt', 'a')  
    @arquivo.puts '                '
    @arquivo.puts "Iniciando conversão de #{mensagem} em #{Time.current}"
  end
  
  def fecha_arquivo_de_erros(mensagem)
    puts  "Terminando conversão de #{mensagem} em #{Time.current}"
    @arquivo.puts "Terminando conversão de #{mensagem} em #{Time.current}"
    @arquivo.puts '                '
    @arquivo.close
  end
  

end