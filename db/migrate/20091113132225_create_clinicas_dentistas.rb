class CreateClinicasDentistas < ActiveRecord::Migration
  def self.up
    create_table :clinicas_dentistas, :id=>false do |t|
      t.integer :clinica_id
      t.integer :dentista_id
    end
  end

  def self.down
    drop_table :clinicas_dentistas
  end
end
