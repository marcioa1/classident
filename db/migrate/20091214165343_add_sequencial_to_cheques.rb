class AddSequencialToCheques < ActiveRecord::Migration
  def self.up
    add_column :cheques, :sequencial, :integer
    add_index :cheques, :sequencial
  end

  def self.down
    remove_index :cheques, :sequencial
    remove_column :cheques, :sequencial
  end
end
