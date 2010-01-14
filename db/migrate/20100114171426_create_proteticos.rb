class CreateProteticos < ActiveRecord::Migration
  def self.up
    create_table :proteticos do |t|
      t.string :nome
      t.string :logradouro
      t.string :numero
      t.string :complemento
      t.string :telefone
      t.string :celular
      t.string :email
      t.string :bairro
      t.string :observacao

      t.timestamps
    end
    add_index :proteticos, :id
    add_index :proteticos, :nome
  end

  def self.down
    drop_table :proteticos
  end
end
