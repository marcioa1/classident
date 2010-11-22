class AddClinicaIdADebitos < ActiveRecord::Migration
  def self.up
    add_column :debitos, :clinica_id, :integer
  end

  def self.down
    remove_column :debitos, :clinica_id
  end
end