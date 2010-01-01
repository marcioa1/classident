class CreateAltas < ActiveRecord::Migration
  def self.up
    create_table :altas do |t|
      t.integer :paciente_id
      t.date :data_inicio
      t.string :observacao
      t.integer :user_id
      t.date :date_termino
      t.integer :user_id_termino
      
      t.timestamps
    end
    add_index :altas, :paciente_id
  end

  def self.down
    drop_table :altas
  end
end
