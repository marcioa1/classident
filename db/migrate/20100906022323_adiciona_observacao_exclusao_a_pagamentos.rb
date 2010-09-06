class AdicionaObservacaoExclusaoAPagamentos < ActiveRecord::Migration
  def self.up
    add_column :pagamentos, :observacao_exclusao, :string
    add_column :pagamentos, :usuario_exclusao, :integer
  end

  def self.down
    remove_column :pagamentos, :usuario_exclusao
    remove_column :pagamentos, :observacao_exclusao
  end
end