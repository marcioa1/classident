class CreateRecebimentos < ActiveRecord::Migration
  def self.up
    create_table :recebimentos do |t|
      t.references   :paciente
      t.references   :clinica
      t.date         :data
      t.references   :formas_recebimento
      t.decimal      :valor, :precision=>9, :scale=>2
      t.string       :observacao , :limit => 50

      t.timestamps
    end
    add_index :recebimentos, :clinica_id
    add_index :recebimentos, :paciente_id
  end

  def self.down
    drop_table :recebimentos
  end
end
