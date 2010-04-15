class CreateFormaRecebimentoTemps < ActiveRecord::Migration
  def self.up
    create_table :forma_recebimento_temps do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :forma_recebimento_temps
  end
end
