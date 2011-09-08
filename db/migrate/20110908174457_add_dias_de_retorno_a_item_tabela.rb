class AddDiasDeRetornoAItemTabela < ActiveRecord::Migration
  def self.up
    add_column :item_tabelas, :dias_de_retorno, :integer, :default => 0
  end

  def self.down
    remove_column :item_tabelas, :dias_de_retorno
  end
end
