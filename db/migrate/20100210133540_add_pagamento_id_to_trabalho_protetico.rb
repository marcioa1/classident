class AddPagamentoIdToTrabalhoProtetico < ActiveRecord::Migration
  def self.up
    add_column :trabalho_proteticos, :pagamento_id, :integer
    add_column :pagamentos, :protetico_id, :integer
  end

  def self.down
    remove_column :pagamentos, :protetico_id
    remove_column :trabalho_proteticos, :pagamento_id
  end
end
