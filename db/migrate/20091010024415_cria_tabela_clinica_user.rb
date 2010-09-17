class CriaTabelaClinicaUser < ActiveRecord::Migration
  def self.up
    create_table :clinicas_users, :id=>false do |t| 
      t.integer :clinica_id
      t.integer :user_id
    end
    # remove_column :users, :clinica_id
  end

  def self.down
    # add_column :users, :clinica_id, :integer
    drop_table :clinicas_users
  end
end
