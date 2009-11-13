class CreateTratamentos < ActiveRecord::Migration
  def self.up
    create_table :tratamentos do |t|
      t.integer :paciente_id
      t.integer :item_tabela_id
      t.integer :dentista_id
      t.decimal :valor, :precision=>2, :scale=>8
      t.date :data
      t.string :dente
      t.integer :orcamento_id

      t.timestamps
    end
    add_index :tratamentos, "id"
    add_index :tratamentos, "paciente_id"
  end

  def self.down
    drop_table :tratamentos
  end
end
