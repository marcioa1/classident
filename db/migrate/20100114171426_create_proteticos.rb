class CreateProteticos < ActiveRecord::Migration
  def self.up
    create_table :proteticos do |t|
      t.string :nome,        :limit => 60
      t.string :logradouro,  :limit => 60
      t.string :numero,      :limit => 10
      t.string :complemento, :limit => 10
      t.string :telefone,    :limit => 20
      t.string :celular,     :limit => 20
      t.string :email,       :limit => 70
      t.string :bairro,      :limit => 50
      t.string :observacao,  :limit => 70

      t.timestamps
    end
    add_index :proteticos, :nome
  end

  def self.down
    drop_table :proteticos
  end
end
