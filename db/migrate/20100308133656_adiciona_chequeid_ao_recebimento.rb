class AdicionaChequeidAoRecebimento < ActiveRecord::Migration
  def self.up
    add_column :recebimentos, :cheque_id, :integer
    add_column :cheques, :recebimento_id_2, :integer
    add_column :cheques, :recebimento_id_3, :integer
  end

  def self.down
    remove_column :cheques, :recebimento_id_3
    remove_column :cheques, :recebimento_id_2
    remove_column :recebimentos, :cheque_id
  end
end
