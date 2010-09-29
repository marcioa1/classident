class CreateContaBancarias < ActiveRecord::Migration
  def self.up
    create_table :conta_bancarias do |t|
      t.string :nome, :limit => 30

      t.timestamps
    end
  end

  def self.down
    drop_table :conta_bancarias
  end
end
