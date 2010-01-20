class CreateTrabalhoProteticos < ActiveRecord::Migration
  def self.up
    create_table :trabalho_proteticos do |t|
      t.integer :dentista_id
      t.integer :protetico_id
      t.integer :paciente_id
      t.string :dente
      t.date :data_de_envio
      t.date :data_prevista_de_devolucao
      t.date :data_de_devolucao
      t.integer :tabela_protetico_id
      t.decimal :valor, :precision=>7, :scale=>2
      t.string :cor
      t.text :observacoes
      t.date :data_de_repeticao
      t.string :motivo_da_repeticao
      t.date :data_prevista_da_devolucao_da_repeticao

      t.timestamps
    end
    add_index :trabalho_proteticos, :protetico_id
    add_index :trabalho_proteticos, :paciente_id
  end

  def self.down
    drop_table :trabalho_proteticos
  end
end
