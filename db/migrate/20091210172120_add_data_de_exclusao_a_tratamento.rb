class AddDataDeExclusaoATratamento < ActiveRecord::Migration
  def self.up
    add_column :tratamentos, :excluido, :boolean, :default=>false
  end

  def self.down
    remove_column :tratamentos, :excluido
  end
end
