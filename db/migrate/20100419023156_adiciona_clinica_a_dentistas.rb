class AdicionaClinicaADentistas < ActiveRecord::Migration
  def self.up
    add_column :dentistas, :clinica_id, :integre
  end

  def self.down
    remove_column :dentistas, :clinica_id
  end
end
