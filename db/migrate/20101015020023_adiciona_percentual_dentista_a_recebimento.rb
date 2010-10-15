class AdicionaPercentualDentistaARecebimento < ActiveRecord::Migration
  def self.up
    add_column :recebimentos, :percentual_dentista, :integer
  end

  def self.down
    remove_column :recebimentos, :percentual_dentista
  end
end