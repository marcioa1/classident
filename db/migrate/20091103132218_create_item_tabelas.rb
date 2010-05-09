class CreateItemTabelas < ActiveRecord::Migration
  def self.up
    create_table :item_tabelas do |t|
      t.integer :tabela_id
      t.string  :codigo
      t.string  :descricao
      t.boolean :ativo, :default=>true
      t.integer :clinica_id

      t.timestamps
    end
    add_index :item_tabelas, :id
    add_index :item_tabelas, :tabela_id
  end

  def self.down
    drop_table :item_tabelas
  end
end
