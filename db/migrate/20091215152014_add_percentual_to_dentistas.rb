class AddPercentualToDentistas < ActiveRecord::Migration
  def self.up
    add_column :dentistas, :especialidade, :string
    add_column :dentistas, :percentual, :decimal, :precision=>9, :scale=>2
    add_column :dentistas, :sequencial, :integer
    add_index :dentistas, :sequencial
  end

  def self.down
    remove_index :dentistas, :sequencial
    remove_column :dentistas, :sequencial
    remove_column :dentistas, :percentual
    remove_column :dentistas, :especialidade
  end
end
