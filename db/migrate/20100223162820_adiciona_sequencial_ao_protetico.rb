class AdicionaSequencialAoProtetico < ActiveRecord::Migration
  def self.up
    add_column :proteticos, :sequencial, :integer
    add_column :proteticos, :cidade, :string, :limit => 50
    add_column :proteticos, :estado, :string, :limit => 2
    add_column :proteticos, :cep, :string, :limit => 9
    add_column :proteticos, :cpf, :string, :limit => 18
    add_column :proteticos, :nascimento, :date
    add_column :tabela_proteticos, :sequencial, :integer
    add_column :pacientes, :sequencial, :integer
  end

  def self.down
    remove_column :pacientes, :sequencial
    remove_column :tabela_proteticos, :sequencial
    remove_column :proteticos, :nascimento
    remove_column :proteticos, :cpf
    remove_column :proteticos, :cep
    remove_column :proteticos, :estado
    remove_column :proteticos, :cidade
    remove_column :proteticos, :sequencial
  end
end
