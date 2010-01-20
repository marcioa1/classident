class CreateClinicasProteticos < ActiveRecord::Migration
  def self.up
     create_table :clinicas_proteticos, :id=>false do |t|
        t.integer :clinica_id
        t.integer :protetico_id
      end
  end

  def self.down
    drop_table :clinicas_proteticos
  end
end
