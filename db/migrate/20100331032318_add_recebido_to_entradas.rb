class AddRecebidoToEntradas < ActiveRecord::Migration
  def self.up
    add_column :entradas, :data_confirmacao_da_entrada, :datetime
  end

  def self.down
    remove_column :entradas, :data_confirmacao_da_entrada
  end
end
