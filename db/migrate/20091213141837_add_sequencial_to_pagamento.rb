class AddSequencialToPagamento < ActiveRecord::Migration
  def self.up
    add_column :pagamentos, :sequencial, :integer
    add_column :pagamentos, :valor_terceiros, :decimal, :precision=>9, :scale=>2, :default => 0
    add_column :pagamentos, :valor_cheque, :decimal, :precision=>9, :scale=>2, :default => 0
    add_column :pagamentos, :valor_restante, :decimal, :precision=>9, :scale=>2, :default => 0
    add_column :pagamentos, :opcao_restante, :integer
    add_column :pagamentos, :conta_bancaria_id, :integer
    add_column :pagamentos, :numero_do_cheque, :string, :limit=>20
    add_index  :pagamentos, :sequencial
  end

  def self.down
    remove_index :pagamentos, :sequencial
    remove_column :pagamentos, :numero_do_cheque
    remove_column :pagamentos, :conta_bancaria_id
    remove_column :pagamentos, :opcao_restante
    remove_column :pagamentos, :valor_restante
    remove_column :pagamentos, :valor_cheque
    remove_column :pagamentos, :valor_terceiros
    remove_column :pagamentos, :sequencial
  end
end
