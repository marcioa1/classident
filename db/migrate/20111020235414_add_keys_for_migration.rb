class AddKeysForMigration < ActiveRecord::Migration
  def self.up
    # add_index :pacientes,  [:nome, :clinica_id], :name =>:nome_clinica_id
    # add_index :tratamentos, [:sequencial, :clinica_id], :name => :sequencial_clinica_id
    # add_index :formas_recebimentos, :nome
    # add_index :tabelas, [:sequencial, :clinica_id], :name => :sequencial_clinica_id
    # add_index :orcamentos, [:numero, :paciente_id, :clinica_id], :name => :numero_paciente_id_clinica_id
    # # add_index :tipo_pagamentos, [:sequencial, :clinica_id], :name => :sequencial_clinica_id
    # add_index :pagamentos, [:sequencial, :clinica_id], :name => :sequencial_clinica_id
    # add_index :tabela_proteticos, :descricao
    # add_index :proteticos, [:sequencial, :clinica_id], :name => :sequencial_clinica_id
    # add_index :tabela_proteticos, [:protetico_id, :sequencial], :name => :protetico_id_sequencial
    add_index :recebimentos, [:sequencial_cheque, :clinica_id]#, :name => :sequencial_cheque_clinica_id
    add_index :pagamentos, [:sequencial, :clinica_id]#, :name => :sequencial_clinica_id
    add_index :orcamentos, [:numero, :paciente_id, :clinica_id]#, :name => :numero_paciente_id_clinica_id
  end

  def self.down
    remove_index :orcamentos, :numero_paciente_id_clinica_id
    remove_index :pagamentos, :sequencial_clinica_id
    remove_index :recebimentos, :sequencial_cheque_clinica_id
    # remove_index :tabela_proteticos , :protetico_id_sequencial
    # remove_index :proteticos, :sequencial_clinica_id
    # remove_index :tabela_proteticos , :descricao
    # remove_index :pagamentos , :sequencial_clinica_id
    # # remove_index :tipo_pagamentos , :sequencial_clinica_id
    # remove_index :orcamentos , :numero_paciente_id_clinica_id
    # remove_index :tabelas , :sequencial_clinica_id
    # remove_index :formas_recebimentos , :nome
    # remove_index :tratamentos , :sequencial_clinica_id
    # remove_index :pacientes , :nome_clinica_id
  end
end
