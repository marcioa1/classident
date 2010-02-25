class AdicionaDentistaAoPagamento < ActiveRecord::Migration
  def self.up
    add_column :pagamentos, :dentista_id, :integer
  end

  def self.down
    remove_column :pagamentos, :dentista_id
  end
end
