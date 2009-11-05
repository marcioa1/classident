class CreateDentistas < ActiveRecord::Migration
  def self.up
    create_table :dentistas do |t|
      t.string :nome
      t.string :telefone
      t.string :celular
      t.boolean :ativo

      t.timestamps
    end
  end

  def self.down
    drop_table :dentistas
  end
end
