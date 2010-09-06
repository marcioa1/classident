class AdicionaObservacaoExclusaoAPagamentos < ActiveRecord::Migration
  def self.up
    add_column :pagamentos, :observacao_exclusao, :string
  end

  def self.down
    remove_column :pagamentos, :observacao_exclusao
  end
end