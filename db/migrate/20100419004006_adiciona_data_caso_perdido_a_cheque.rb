class AdicionaDataCasoPerdidoACheque < ActiveRecord::Migration
  def self.up
    add_column :cheques, :data_caso_perdido, :date
  end

  def self.down
    remove_column :cheques, :data_caso_perdido
  end
end
