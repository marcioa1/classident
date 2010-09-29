class AddExclusaoToRecebimento < ActiveRecord::Migration
  def self.up
    add_column :recebimentos, :data_de_exclusao, :date
    add_column :recebimentos, :observacao_exclusao, :string, :limit => 50
  end

  def self.down
    remove_column :recebimentos, :observacao_exclusao
    remove_column :recebimentos, :data_de_exclusao
  end
end
