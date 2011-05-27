class AddMissingIndex < ActiveRecord::Migration
  def self.up
    add_index :tratamentos, :paciente_id
    # add_index :pacientes, :dentista_id
    add_index :pacientes, :ortodontista_id
    add_index :trabalho_proteticos, :paciente_id
    add_index :trabalho_proteticos, :protetico_id
    # add_index :trabalho_proteticos, :cheque_id
    add_index :tabelas, :clinica_id
    add_index :tabela_proteticos, :protetico_id
    # add_index :acompanhamento_cheques, :user_id
    add_index :acompanhamento_cheques, :cheque_id
    add_index :destinacaos, :clinica_id
    add_index :pagamentos, :conta_bancaria_id
    add_index :pagamentos, :clinica_id
    # add_index :altas, :paciente_id
    # add_index :altas, :user_termino_id
    # add_index :clinicas_users, [:user_id, :clinica_id]
    # add_index :clinicas_users, [:clinica_id, :user_id]
    add_index :debitos, :paciente_id
    add_index :abonos, :paciente_id
    add_index :entradas, :clinica_destino
    add_index :entradas, :clinica_id
    add_index :users, :tipo_usuario_id
    # add_index :users, :alta_id
  end

  def self.down
    remove_index :tratamentos, :paciente_id
    # remove_index :pacientes, :dentista_id
    remove_index :pacientes, :ortodontista_id
    remove_index :trabalho_proteticos, :paciente_id
    remove_index :trabalho_proteticos, :protetico_id
    # remove_index :trabalho_proteticos, :cheque_id
    remove_index :tabelas, :clinica_id
    remove_index :tabela_proteticos, :protetico_id
    # remove_index :acompanhamento_cheques, :user_id
    remove_index :acompanhamento_cheques, :cheque_id
    remove_index :destinacaos, :clinica_id
    remove_index :pagamentos, :conta_bancaria_id
    remove_index :pagamentos, :clinica_id
    # remove_index :altas, :paciente_id
    # remove_index :altas, :user_termino_id
    # remove_index :clinicas_users, :column => [:user_id, :clinica_id]
    # remove_index :clinicas_users, :column => [:clinica_id, :user_id]
    remove_index :debitos, :paciente_id
    remove_index :abonos, :paciente_id
    remove_index :entradas, :clinica_destino
    remove_index :entradas, :clinica_id
    remove_index :users, :tipo_usuario_id
    # remove_index :users, :alta_id
  end
end
