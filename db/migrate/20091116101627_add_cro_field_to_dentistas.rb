class AddCroFieldToDentistas < ActiveRecord::Migration
  def self.up
    add_column :dentistas, :cro, :string
  end

  def self.down
    remove_column :dentistas, :cro
  end
end
