class AddIndicacaoToPacientes < ActiveRecord::Migration
  def self.up
    add_column :pacientes, :indicacao_id, :integer
  end

  def self.down
    remove_column :pacientes, :indicacao_id
  end
end
