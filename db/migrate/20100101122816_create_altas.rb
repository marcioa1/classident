class CreateAltas < ActiveRecord::Migration
  def self.up
    create_table :altas do |t|
      t.references :paciente
      t.date       :data_inicio
      t.string     :observacao, :limit => 50
      t.references :user
      t.date       :data_termino
      t.references :user_termino
      
      t.timestamps
    end
  end

  def self.down
    drop_table :altas
  end
end
