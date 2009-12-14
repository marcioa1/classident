class CreateContaBancarias < ActiveRecord::Migration
  def self.up
    create_table :conta_bancarias do |t|
      t.string :nome

      t.timestamps
    end
    add_index :conta_bancarias, :id
  end

  def self.down
    drop_table :conta_bancarias
  end
end
