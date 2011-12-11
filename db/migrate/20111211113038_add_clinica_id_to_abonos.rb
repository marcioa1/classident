class AddClinicaIdToAbonos < ActiveRecord::Migration
  def self.up
    add_column :abonos, :clinica_id, :integer
  end

  def self.down
    remove_column :abonos, :clinica_id
  end
end