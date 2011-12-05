class AddCanceladoToDebito < ActiveRecord::Migration
  def self.up
    add_column :debitos, :cancelado, :boolean, :default => false
  end

  def self.down
    remove_column :debitos, :cancelado
  end
end