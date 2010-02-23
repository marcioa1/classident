class AdicionaClinicaAoOrcamento < ActiveRecord::Migration
  def self.up
    add_column :orcamentos, :clinica_id, :integer
  end

  def self.down
    remove_column :orcamentos, :clinica_id
  end
end
