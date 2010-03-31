class AddRecebidoToEntradas < ActiveRecord::Migration
  def self.up
    add_column :entradas, :data_confirmacao_do_recebimento, :datetime
  end

  def self.down
    remove_column :entradas, :data_confirmacao_do_recebimento
  end
end
