class AddDiasDeRetornoAItemTabela < ActiveRecord::Migration
  def self.up
    add_column :item_tabelas, :dias_de_retorno, :integer, :default => 0
    add_column :item_tabelas, :tem_custo_de_protetico, :boolean, :default => false
  end

  def self.down
    remove_column :item_tabelas, :dias_de_retorno
    remove_column :tem_custo_de_protetico
  end
end
