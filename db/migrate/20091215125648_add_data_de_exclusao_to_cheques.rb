class AddDataDeExclusaoToCheques < ActiveRecord::Migration
  def self.up
    add_column :cheques, :data_de_exclusao, :date
  end

  def self.down
    remove_column :cheques, :data_de_exclusao
  end
end
