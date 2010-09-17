class CreateFormaRecebimentoTemps < ActiveRecord::Migration
  def self.up
    create_table :forma_recebimento_temps do |t|
      t.integer     :seq  
      t.integer     :clinica_id
      t.string      :nome, :limit => 40
      t.integer     :id_adm
      t.timestamps
    end
  end

  def self.down
    drop_table :forma_recebimento_temps
  end
end
