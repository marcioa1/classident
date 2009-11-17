class AddCodigoNaClinicaToPacientes < ActiveRecord::Migration
  def self.up
    add_column :pacientes, :codigo, :integer
  end

  def self.down
    remove_column :pacientes, :codigo
  end
end
