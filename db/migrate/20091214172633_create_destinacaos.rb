class CreateDestinacaos < ActiveRecord::Migration
  def self.up
    create_table :destinacaos do |t|
      t.string     :nome, :limit=> 30
      t.integer    :sequencial
      t.references :clinica
      t.timestamps
    end
    add_column :cheques, :destinacao_id, :integer
    add_column :cheques, :data_destinacao, :date
    add_index :destinacaos, :id
  end

  def self.down
    remove_column :cheques, :data_destinacao
    remove_column :cheques, :destinacao_id
    drop_table :destinacaos
  end
end
