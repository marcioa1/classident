class CreateRecebimentos < ActiveRecord::Migration
  def self.up
    create_table :recebimentos do |t|
      t.integer :paciente_id
      t.integer :clinica_id
      t.date :data
      t.integer :formas_recebimento_id
      t.decimal :valor, :precision=>9, :scale=>2
      t.string :observacao

      t.timestamps
    end
    add_index :recebimentos, :clinica_id
    add_index :recebimentos, :paciente_id
  end

  def self.down
    drop_table :recebimentos
  end
end
