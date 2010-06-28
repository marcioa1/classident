class AdicionIndicesACheque < ActiveRecord::Migration
  def self.up
    add_index :cheques, :data_entrega_administracao
    add_index :cheques, :data_recebimento_na_administracao
  end

  def self.down
    remove_index :cheques, :data_recebimento_na_administracao
    remove_index :cheques, :data_entrega_administracao
  end
end