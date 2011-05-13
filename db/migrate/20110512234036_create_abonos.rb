class CreateAbonos < ActiveRecord::Migration
  def self.up
    create_table :abonos do |t|
      t.date       :data
      t.references :user
      t.references :paciente
      t.decimal    :valor, :precision => 8, :scale => 2
      t.string     :observacao, :limit => 64
      t.timestamps
    end
  end

  def self.down
    drop_table :abonos
  end
end
