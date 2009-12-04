class AddClinicaIdFieldToTratamento < ActiveRecord::Migration
  def self.up
    add_column :tratamentos, :clinica_id, :integer
  end

  def self.down
    remove_column :tratamentos, :clinica_id
  end
end
