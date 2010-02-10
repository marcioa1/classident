class AddClinicaIdToTrabalhoProtetico < ActiveRecord::Migration
  def self.up
    add_column :trabalho_proteticos, :clinica_id, :integer
  end

  def self.down
    remove_column :trabalho_proteticos, :clinica_id
  end
end
