class CreateTabelas < ActiveRecord::Migration
  def self.up
    create_table :tabelas do |t|
      t.string :nome
      t.boolean :ativa
      t.timestamps
    end
    add_index :tabelas, :id
  end

  def self.down
    drop_table :tabelas
  end
end
