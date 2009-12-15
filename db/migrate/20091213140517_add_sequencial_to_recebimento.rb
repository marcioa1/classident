class AddSequencialToRecebimento < ActiveRecord::Migration
  def self.up
    add_column :recebimentos, :sequencial, :integer
    add_index :recebimentos, :sequencial
  end

  def self.down
    remove_index :recebimentos, :sequencial
    remove_column :recebimentos, :sequencial
  end
end
