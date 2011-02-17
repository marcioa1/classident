class CreateMensalidadeOrtodontias < ActiveRecord::Migration
  def self.up
    create_table :mensalidade_ortodontias, :id => false do |t|
      t.date    :data
      t.integer :clinica_id
      t.timestamps
    end
  end

  def self.down
    drop_table :mensalidade_ortodontias
  end
end
