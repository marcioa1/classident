class AdicionaCodigoAnteriorAPaciente < ActiveRecord::Migration
  def self.up
    add_column :pacientes, :codigo_anterior, :string
  end

  def self.down
    remove_column :pacientes, :codigo_anterior
  end
end