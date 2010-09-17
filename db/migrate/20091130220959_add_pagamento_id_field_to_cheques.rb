class AddPagamentoIdFieldToCheques < ActiveRecord::Migration
  def self.up
    add_column :cheques, :pagamento_id, :integer
    add_index :cheques, :pagamento_id
  end

  def self.down
    remove_index :cheques, :pagamento_id
    remove_column :cheques, :pagamento_id
  end
end