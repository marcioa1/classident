class AddTipoAFormasRecebimento < ActiveRecord::Migration
  def self.up
    add_column :formas_recebimentos, :tipo, :string, :limit=>1
  end

  def self.down
    remove_column :formas_recebimentos, :tipo
  end
end