class AddATivoToFormasRecebimento < ActiveRecord::Migration
  def self.up
    add_column :formas_recebimentos, :ativo, :boolean, :default => true
  end

  def self.down
    remove_column :formas_recebimentos, :ativo
  end
end
