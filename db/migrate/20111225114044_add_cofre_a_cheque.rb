class AddCofreACheque < ActiveRecord::Migration
  def self.up
    add_column :cheques, :data_envio_ao_cofre, :date
    add_column :cheques, :data_entrada_no_cofre, :date
    add_column :cheques, :data_saida_do_cofre, :date
    add_column :cheques, :data_recebimento_do_cofre, :date
  end

  def self.down
    remove_column :cheques, :data_retorno_do_cofre
    remove_column :cheques, :data_entrega_ao_cofre
  end
end