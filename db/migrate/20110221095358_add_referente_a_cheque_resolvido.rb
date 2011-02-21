class AddReferenteAChequeResolvido < ActiveRecord::Migration
  def self.up
    add_column :entradas, :resolucao_de_cheque, :boolean, :default=>false
  end

  def self.down
    remove_column :entradas, :resolucao_de_cheque
  end
end