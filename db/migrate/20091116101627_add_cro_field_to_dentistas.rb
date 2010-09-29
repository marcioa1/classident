class AddCroFieldToDentistas < ActiveRecord::Migration
  def self.up
    add_column :dentistas, :cro, :string, :limit => 12
  end

  def self.down
    remove_column :dentistas, :cro
  end
end
