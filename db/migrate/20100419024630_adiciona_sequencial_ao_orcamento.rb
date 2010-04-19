class AdicionaSequencialAoOrcamento < ActiveRecord::Migration
  def self.up
    add_column :orcamentos, :sequencial, :integer
  end

  def self.down
    remove_column :orcamentos, :sequencial
  end
end
