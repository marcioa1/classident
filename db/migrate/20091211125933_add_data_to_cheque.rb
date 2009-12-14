class AddDataToCheque < ActiveRecord::Migration
  def self.up
    add_column :cheques, :data, :date
  end

  def self.down
    remove_column :cheques, :data
  end
end
