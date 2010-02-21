class CreateIndicacaos < ActiveRecord::Migration
  def self.up
    create_table :indicacaos do |t|
      t.string :descricao
      t.boolean :ativo, :default=>true

      t.timestamps
    end
  end

  def self.down
    drop_table :indicacaos
  end
end
