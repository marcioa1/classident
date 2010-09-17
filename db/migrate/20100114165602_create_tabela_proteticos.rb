class CreateTabelaProteticos < ActiveRecord::Migration
  def self.up
    create_table :tabela_proteticos do |t|
      t.references :protetico
      t.string     :codigo, :limit => 20
      t.string     :descricao, :limit => 70
      t.decimal    :valor, :precision=>8, :scale=>2

      t.timestamps
    end
  end

  def self.down
    drop_table :tabela_proteticos
  end
end
