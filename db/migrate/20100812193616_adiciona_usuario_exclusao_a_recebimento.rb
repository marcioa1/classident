class AdicionaUsuarioExclusaoARecebimento < ActiveRecord::Migration
  def self.up
    add_column :recebimentos, :usuario_exclusao, :integer
  end

  def self.down
    remove_column :recebimentos, :usuario_exclusao
  end
end