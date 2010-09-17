class AddDevolucaoToCheque < ActiveRecord::Migration
  def self.up
    add_column :cheques, :data_primeira_devolucao, :date
    add_column :cheques, :motivo_primeira_devolucao, :string, :limit => 30
    add_column :cheques, :data_lancamento_primeira_devolucao, :date
    add_column :cheques, :data_reapresentacao, :date
    add_column :cheques, :data_segunda_devolucao, :date
    add_column :cheques, :motivo_segunda_devolucao, :string, :limit => 30
    add_column :cheques, :data_solucao, :date
    add_column :cheques, :descricao_solucao, :string, :limit => 30
    add_column :cheques, :reapresentacao, :boolean
    add_column :cheques, :data_spc, :date
    add_column :cheques, :data_arquivo_morto, :date
  end

  def self.down
    remove_column :cheques, :data_arquivo_morto
    remove_column :cheques, :data_spc
    remove_column :cheques, :reapresentacao
    remove_column :cheques, :descricao_solucao
    remove_column :cheques, :data_solucao
    remove_column :cheques, :motivo_segunda_Devolucao
    remove_column :cheques, :data_segunda_devolucao
    remove_column :cheques, :data_reapresentacao
    remove_column :cheques, :data_lancamento_primeira_devolucao
    remove_column :cheques, :motivo_primeira_devolucao
    remove_column :cheques, :data_primeira_devolucao
  end
end
