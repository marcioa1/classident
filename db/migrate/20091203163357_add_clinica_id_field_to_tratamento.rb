class AddClinicaIdFieldToTratamento < ActiveRecord::Migration
  def self.up
    add_column :tratamentos, :clinica_id, :integer
    add_index :tratamentos, :clinica_id
  end

  def self.down
    remove_index :tratamentos, :clinica_id
    remove_column :tratamentos, :clinica_id
  end
end