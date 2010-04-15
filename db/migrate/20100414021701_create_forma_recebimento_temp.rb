class CreateFormaRecebimentoTemp < ActiveRecord::Migration
  def self.up
    create_table :forma_recebimentos_temp do |t|
      t.integer  :id_adm
      t.integer  :sequencial
      t.integer  :clinica_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :forma_recebimentos_temp
  end
  
end
