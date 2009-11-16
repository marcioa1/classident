class CreateDebitos < ActiveRecord::Migration
  def self.up
    create_table :debitos do |t|
      t.integer :paciente_id
      t.integer :tratamento_id
      t.decimal :valor
      t.string :descricao
      t.date :data

      t.timestamps
    end
    add_index :debitos, :paciente_id
  end

  def self.down
    drop_table :debitos
  end
end
