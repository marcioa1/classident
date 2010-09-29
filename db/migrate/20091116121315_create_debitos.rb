class CreateDebitos < ActiveRecord::Migration
  def self.up
    create_table :debitos do |t|
      t.references  :paciente
      t.references  :tratamento
      t.decimal     :valor, :precision=>9 , :scale=>2
      t.string      :descricao, :limit => 50
      t.date        :data

      t.timestamps
    end
  end

  def self.down
    drop_table :debitos
  end
end
