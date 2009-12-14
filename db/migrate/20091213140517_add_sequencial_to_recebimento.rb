class AddSequencialToRecebimento < ActiveRecord::Migration
  def self.up
    add_column :recebimentos, :sequencial, :integer
    add_index :recebimentos, :sequencial
  end

  def self.down
    remove_column :recebimentos, :sequencial
    remove_index :recebimentos, :sequencial
  end
end
