class CreateEntradas < ActiveRecord::Migration
  def self.up
    create_table :entradas do |t|
      t.date :data
      t.decimal :valor, :precision=>8, :scale=>2
      t.string :observacao
      t.integer :clinica_id

      t.timestamps
    end
    add_index :entradas, :id
    add_index :entradas, :data
    add_index :entradas, :clinica_id
  end

  def self.down
    drop_table :entradas
  end
end
