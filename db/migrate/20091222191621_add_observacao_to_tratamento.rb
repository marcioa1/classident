class AddObservacaoToTratamento < ActiveRecord::Migration
  def self.up
    add_column :tratamentos, :custo, :decimal, :precision=>9, :scale=>2
    add_column :tratamentos, :face, :string, :limit => 10
    add_column :tratamentos, :descricao, :string, :limit=>60
    add_column :tratamentos, :sequencial, :integer
    add_index :tratamentos, :sequencial
  end

  def self.down
    remove_column :tratamentos, :custo
    remove_column :tratamentos, :face
    remove_index :tratamentos, :sequencial
    remove_column :tratamentos, :sequencial
    remove_column :tratamentos, :descricao
  end
end
