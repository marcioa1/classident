class CreateFormasRecebimentos < ActiveRecord::Migration
  def self.up
    create_table :formas_recebimentos do |t|
      t.string   :nome,  :limit => 40
      
      t.timestamps
    end
  end

  def self.down
    drop_table :formas_recebimentos
  end
end
