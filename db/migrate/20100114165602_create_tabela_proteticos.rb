class CreateTabelaProteticos < ActiveRecord::Migration
  def self.up
    create_table :tabela_proteticos do |t|
      t.references :protetico
      t.string :codigo
      t.string :descricao
      t.decimal :valor, :precision=>8, :scale=>2

      t.timestamps
    end
    add_index :tabela_proteticos, :protetico_id 
  end

  def self.down
    drop_table :tabela_proteticos
  end
end
