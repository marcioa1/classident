class AddBomParaToCheques < ActiveRecord::Migration
  def self.up
    add_column :cheques, :bom_para, :date
    add_column :cheques, :clinica_id, :integer
  end

  def self.down
    remove_column :cheques, :bom_para
    remove_column :cheques, :clinica_id
  end
end
