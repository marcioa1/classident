class RemoveColunasDeCheque < ActiveRecord::Migration
  def self.up
    remove_column :cheques, :recebimento_id_2
    remove_column :cheques, :recebimento_id_3
    remove_column :cheques, :valor_primeiro_paciente
    remove_column :cheques, :valor_segundo_paciente
    remove_column :cheques, :valor_terceiro_paciente
    remove_column :cheques, :paciente_id
    remove_column :cheques, :segundo_paciente
    remove_column :cheques, :terceiro_paciente
    remove_column :cheques, :recebimento_id
  end

  def self.down
    add_column :cheques, :recebimento_id, :integer
    add_column :cheques, :terceiro_paciente, :integer
    add_column :cheques, :segundo_paciente, :integer
    add_column :cheques, :paciente_id, :integer
    add_column :cheques, :valor_terceiro_paciente, :decimal,            :precision => 9, :scale => 2
    add_column :cheques, :valor_segundo_paciente, :decimal,             :precision => 9, :scale => 2
    add_column :cheques, :valor_primeiro_paciente, :decimal,            :precision => 9, :scale => 2
    add_column :cheques, :recebimento_id_3, :integer
    add_column :cheques, :recebimento_id_2, :integer
  end
end
