class CreateEntradas < ActiveRecord::Migration
  def self.up
    create_table :entradas do |t|
      t.date       :data
      t.decimal    :valor, :precision=>8, :scale=>2
      t.string     :observacao, :limit => 50
      t.references :clinica

      t.timestamps
    end
    add_index :entradas, :data
  end

  def self.down
    drop_table :entradas
  end
end
