class CreateTrabalhoProteticos < ActiveRecord::Migration
  def self.up
    create_table :trabalho_proteticos do |t|
      t.references :dentista
      t.references :protetico
      t.references :paciente
      t.string     :dente, :limit => 12
      t.date       :data_de_envio
      t.date       :data_prevista_de_devolucao
      t.date       :data_de_devolucao
      t.references :tabela_protetico
      t.decimal    :valor, :precision=>7, :scale=>2
      t.string     :cor,  :limit => 12
      t.text       :observacoes
      t.date       :data_de_repeticao
      t.string     :motivo_da_repeticao, :limit => 30
      t.date       :data_prevista_da_devolucao_da_repeticao

      t.timestamps
    end
  end

  def self.down
    drop_table :trabalho_proteticos
  end
end
