class CreatePacientes < ActiveRecord::Migration
  def self.up
    create_table :pacientes do |t|
      t.string :nome
      t.string :logradouro
      t.string :numero, :limit=>10
      t.string :complemento, :limit=>10
      t.string :telefone, :limit=> 50
      t.string :celular, :limit=>50
      t.string :email, :limit=>120
      t.integer :tabela_id
      t.date :inicio_tratamento
      t.date :nascimento
      t.string :bairro, :limit=>30
      t.string :cidade, :limit=>30
      t.string :uf, :limit=>2
      t.string :cep, :limit=>8
      t.string :cpf, :limit=>14
      t.string :sexo, :limit=> 1

      t.timestamps
    end
    add_index :pacientes, :id
    add_index :pacientes, :nome
  end

  def self.down
    drop_table :pacientes
  end
end
