class AdiocionaIndicesAsTabelas < ActiveRecord::Migration
    def self.up
      add_index :tratamentos, :orcamento_id
      add_index :tratamentos, :dentista_id
      add_index :tratamentos, :item_tabela_id
      add_index :recebimentos, :cheque_id
      add_index :recebimentos, :formas_recebimento_id
      add_index :item_tabelas, :descricao_conduta_id
      add_index :pacientes, :tabela_id
      add_index :pacientes, :clinica_id
      add_index :pacientes, :sequencial
     # add_index :pacientes, :ortodontista_id
    #  add_index :pacientes, :dentista_id
      add_index :pacientes, :indicacao_id
      add_index :trabalho_proteticos, :clinica_id
    #  add_index :trabalho_proteticos, :cheque_id
      add_index :trabalho_proteticos, :dentista_id
      add_index :trabalho_proteticos, :tabela_protetico_id
      add_index :clinicas_proteticos, [:protetico_id, :clinica_id]
      add_index :clinicas_proteticos, [:clinica_id, :protetico_id]
      add_index :precos, :item_tabela_id
      add_index :conta_bancarias, :clinica_id
      add_index :pagamentos, :tipo_pagamento_id
      add_index :pagamentos, :protetico_id
      add_index :pagamentos, :dentista_id
      add_index :pagamentos, :pagamento_id
      add_index :cheques, :destinacao_id
      add_index :cheques, :banco_id
      add_index :orcamentos, :dentista_id
      add_index :orcamentos, :paciente_id
   #   add_index :users, :alta_id
      add_index :altas, :user_id
      add_index :clinicas_dentistas, [:dentista_id, :clinica_id]
      add_index :clinicas_dentistas, [:clinica_id, :dentista_id]
    end

    def self.down
    remove_index :pacientes, :sequencial
      remove_index :tratamentos, :clinica_id
      remove_index :tratamentos, :orcamento_id
      remove_index :tratamentos, :dentista_id
      remove_index :tratamentos, :item_tabela_id
      remove_index :recebimentos, :cheque_id
      remove_index :recebimentos, :formas_recebimento_id
      remove_index :item_tabelas, :descricao_conduta_id
      remove_index :pacientes, :tabela_id
      remove_index :pacientes, :clinica_id
     # remove_index :pacientes, :ortodontista_id
     # remove_index :pacientes, :dentista_id
      remove_index :pacientes, :indicacao_id
      remove_index :trabalho_proteticos, :clinica_id
    #  remove_index :trabalho_proteticos, :cheque_id
      remove_index :trabalho_proteticos, :dentista_id
      remove_index :trabalho_proteticos, :tabela_protetico_id
      remove_index :clinicas_proteticos, :column => [:protetico_id, :clinica_id]
      remove_index :clinicas_proteticos, :column => [:clinica_id, :protetico_id]
      remove_index :precos, :item_tabela_id
      remove_index :conta_bancarias, :clinica_id
      remove_index :pagamentos, :tipo_pagamento_id
      remove_index :pagamentos, :protetico_id
      remove_index :pagamentos, :dentista_id
      remove_index :pagamentos, :pagamento_id
      remove_index :cheques, :clinica_id
      remove_index :cheques, :destinacao_id
      remove_index :cheques, :banco_id
      remove_index :cheques, :pagamento_id
      remove_index :orcamentos, :dentista_id
      remove_index :orcamentos, :paciente_id
      remove_index :users, :clinica_id
   #   remove_index :users, :alta_id
      remove_index :altas, :user_id
      remove_index :clinicas_dentistas, :column => [:dentista_id, :clinica_id]
      remove_index :clinicas_dentistas, :column => [:clinica_id, :dentista_id]
    end

end