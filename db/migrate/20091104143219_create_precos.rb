class CreatePrecos < ActiveRecord::Migration
  def self.up
    create_table :precos do |t|
      t.integer :clinica_id
      t.integer :item_tabela_id
      t.decimal :preco, :precision=>2, :scale=>8

      t.timestamps
    end
    add_index :precos, :id
    add_index :precos, :clinica_id
  end

  def self.down
    drop_table :precos
  end
end
