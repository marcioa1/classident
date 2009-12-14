class CreateDestinacaos < ActiveRecord::Migration
  def self.up
    create_table :destinacaos do |t|
      t.string :nome
      t.integer :sequencial
      t.integer :clinica_id
      t.timestamps
    end
    add_column :cheques, :destinacao_id, :integer
    add_column :cheques, :data_destinacao, :date
    add_index :destinacaos, :id
    add_index :destinacaos, :clinica_id
  end

  def self.down
    remove_column :cheques, :data_destinacao
    remove_column :cheques, :destinacao_id
    drop_table :destinacaos
  end
end
