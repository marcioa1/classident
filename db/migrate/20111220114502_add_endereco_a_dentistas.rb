class AddEnderecoADentistas < ActiveRecord::Migration
  def self.up
    add_column :dentistas, :logradouro, :string
    add_column :dentistas, :numero, :string
    add_column :dentistas, :complemento, :string
    add_column :dentistas, :bairro, :string
    add_column :dentistas, :municipio, :string
    add_column :dentistas, :cep, :string
    add_column :dentistas, :data_nascimento, :string
    add_column :dentistas, :cpf, :string
    add_column :dentistas, :email, :string
  end

  def self.down
    remove_column :dentistas, :email
    remove_column :dentistas, :cpf
    remove_column :dentistas, :data_nascimento
    remove_column :dentistas, :cep
    remove_column :dentistas, :municipio
    remove_column :dentistas, :bairro
    remove_column :dentistas, :complemento
    remove_column :dentistas, :numero
    remove_column :dentistas, :logradouro
  end
end