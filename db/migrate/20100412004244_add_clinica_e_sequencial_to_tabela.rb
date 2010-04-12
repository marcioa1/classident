class AddClinicaESequencialToTabela < ActiveRecord::Migration
  def self.up
    add_column :tabelas, :clinica, :string
    add_column :tabelas, :sequencial, :integer
    add_column :item_tabelas, :sequencial, :integer
    add_column :item_tabelas, :clinica, :string
  end

  def self.down
    remove_column :item_tabelas, :clinica
    remove_column :item_tabelas, :sequencial
    remove_column :tabelas, :sequencial
    remove_column :tabelas, :clinica
  end
end
