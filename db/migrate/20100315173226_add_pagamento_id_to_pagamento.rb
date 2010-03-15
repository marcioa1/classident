class AddPagamentoIdToPagamento < ActiveRecord::Migration
  def self.up
    add_column :pagamentos, :pagamento_id, :integer
  end

  def self.down
    remove_column :pagamentos, :pagamento_id
  end
end
