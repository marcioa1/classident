class CreateFormasRecebimentos < ActiveRecord::Migration
  def self.up
    create_table :formas_recebimentos do |t|
      t.string :nome

      t.timestamps
    end
    add_index :formas_recebimentos, :id
  end

  def self.down
    drop_table :formas_recebimentos
  end
end
