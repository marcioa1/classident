class AddSequencialChequeToRecebimento < ActiveRecord::Migration
  def self.up
    add_column :recebimentos, :sequencial_cheque, :integer
  end

  def self.down
    remove_column :recebimentos, :sequencial_cheque
  end
end