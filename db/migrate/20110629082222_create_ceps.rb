class CreateCeps < ActiveRecord::Migration
  def self.up
    create_table :ceps do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :ceps
  end
end
