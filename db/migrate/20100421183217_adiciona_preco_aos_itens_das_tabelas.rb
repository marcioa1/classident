class AdicionaPrecoAosItensDasTabelas < ActiveRecord::Migration
  def self.up
    add_column :item_tabelas, :preco, :decimal, :precision=>9, :scale=>2
  end

  def self.down
    remove_column :item_tabelas, :preco
  end
end
