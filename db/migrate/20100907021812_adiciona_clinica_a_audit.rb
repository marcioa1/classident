class AdicionaClinicaAAudit < ActiveRecord::Migration
  def self.up
    add_column :audits, :clinica_id, :integer
    # add_index :audits, :clinica_id
  end

  def self.down
    # remove_index :audits, :clinica_id
    remove_column :audits, :clinica_id
  end
end