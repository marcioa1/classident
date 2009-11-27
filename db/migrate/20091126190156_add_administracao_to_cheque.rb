class AddAdministracaoToCheque < ActiveRecord::Migration
  def self.up
    add_column :cheques, :data_entrega_administracao, :date
  end

  def self.down
    remove_column :cheques, :data_entrega_administracao
  end
end
