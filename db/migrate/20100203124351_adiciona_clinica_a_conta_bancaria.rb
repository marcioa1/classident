class AdicionaClinicaAContaBancaria < ActiveRecord::Migration
  def self.up
    add_column :conta_bancarias, :clinica_id, :integer
  end

  def self.down
    remove_column :conta_bancarias, :clinica_id
  end
end
