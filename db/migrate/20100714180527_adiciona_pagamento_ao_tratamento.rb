class AdicionaPagamentoAoTratamento < ActiveRecord::Migration
  def self.up
    add_column :tratamentos, :pagamento_id, :integer
  end

  def self.down
    remove_column :tratamentos, :pagamento_id
  end
end