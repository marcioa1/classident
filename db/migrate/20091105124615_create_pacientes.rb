class CreatePacientes < ActiveRecord::Migration
  def self.up
    create_table :pacientes do |t|
      t.string :nome,               :size => 80
      t.string :logradouro,         :size => 80
      t.string :numero,             :limit=>10
      t.string :complemento,        :limit=>10
      t.string :telefone,           :limit=> 50
      t.string :celular,            :limit=>50
      t.string :email,              :limit=>120
      t.references :tabela
      t.date :inicio_tratamento
      t.date :nascimento
      t.string :bairro,             :limit=>30
      t.string :cidade,             :limit=>30
      t.string :uf,                 :limit=>2
      t.string :cep,                :limit=>9
      t.string :cpf,                :limit=>14
      t.string :sexo,               :limit=> 1
      t.references :clinica

      t.timestamps
    end
    add_index :pacientes, :id
    add_index :pacientes, :nome
  end

  def self.down
    drop_table :pacientes
  end
end
