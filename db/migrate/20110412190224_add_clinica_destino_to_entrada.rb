class AddClinicaDestinoToEntrada < ActiveRecord::Migration
  def self.up
    add_column :entradas, :clinica_destino, :integer
  end

  def self.down
    remove_column :entradas, :clinica_destino
  end
end