class AdicionaClinicaAAlta < ActiveRecord::Migration
  def self.up
    add_column :altas, :clinica_id, :integer
  end

  def self.down
    remove_column :altas, :clinica_id
  end
end
