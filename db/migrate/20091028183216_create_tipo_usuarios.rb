class CreateTipoUsuarios < ActiveRecord::Migration
  def self.up
    create_table :tipo_usuarios do |t|
      t.string :nome
      t.string :descricao
      t.integer :nivel

      t.timestamps
    end
    add_index :tipo_usuarios, :id
  end

  def self.down
    drop_table :tipo_usuarios
  end
end
