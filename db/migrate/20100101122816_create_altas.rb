class CreateAltas < ActiveRecord::Migration
  def self.up
    create_table :altas do |t|
      t.integer :paciente_id
      t.date :data_inicio
      t.string :observacao
      t.integer :user_id
      t.date :data_termino
      t.integer :user_termino_id
      
      t.timestamps
    end
    add_index :altas, :paciente_id
    add_index :altas, :user_termino_id
  end

  def self.down
    drop_table :altas
  end
end
