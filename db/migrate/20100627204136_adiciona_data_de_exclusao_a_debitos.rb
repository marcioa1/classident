class AdicionaDataDeExclusaoADebitos < ActiveRecord::Migration
  def self.up
    add_column :debitos, :data_de_exclusao, :date
  end

  def self.down
    remove_column :debitos, :data_de_exclusao
  end
end