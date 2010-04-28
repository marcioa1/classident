class AdicionaSeqEClinicaAProteticos < ActiveRecord::Migration
  def self.up
    add_column :proteticos, :clinica_id, :integer
    add_index :proteticos, :clinica_id
  end

  def self.down
    remove_index :proteticos, :clinica_id
    remove_column :proteticos, :clinica_id
  end
end
