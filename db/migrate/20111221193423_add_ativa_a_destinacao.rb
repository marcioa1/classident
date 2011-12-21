class AddAtivaADestinacao < ActiveRecord::Migration
  def self.up
    add_column :destinacaos, :ativa, :boolean, :default => true
  end

  def self.down
    remove_column :destinacaos, :ativa
  end
end