class CreateDentistas < ActiveRecord::Migration
  def self.up
    create_table :dentistas do |t|
      t.string :nome,       :size => 60
      t.string :telefone,   :size => 30
      t.string :celular,    :size => 20
      t.boolean :ativo,     :default => true
      t.references :clinica

      t.timestamps
    end
  end

  def self.down
    drop_table :dentistas
  end
end
