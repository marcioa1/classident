class CreateTratamentos < ActiveRecord::Migration
  def self.up
    create_table :tratamentos do |t|
      t.references   :paciente
      t.references   :item_tabela
      t.references   :dentista
      t.decimal      :valor, :precision=>9, :scale=>2
      t.date         :data
      t.string       :dente, :limit => 6
      t.references   :orcamento

      t.timestamps
    end
  end

  def self.down
    drop_table :tratamentos
  end
end
