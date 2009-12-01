class AddPagamentoIdFieldToCheques < ActiveRecord::Migration
  def self.up
    add_column :cheques, :pagamento_id, :integer
  end

  def self.down
    remove_column :cheques, :pagamento_id
  end
end
