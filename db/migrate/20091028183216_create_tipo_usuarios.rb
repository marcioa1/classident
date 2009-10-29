class CreateTipoUsuarios < ActiveRecord::Migration
  def self.up
    create_table :tipo_usuarios do |t|
      t.string :nome
      t.string :descricao
      t.integer :nivel

      t.timestamps
    end
    add_index :tipo_usuarios, :id
    TipoUsuario.create(:nome "master", :descricao "Tem total acesso as rotias rotinas do sistema", :nivel 0)
    TipoUsuario.create(:nome "administração", :descricao "Tem total ao modulo de administracao e as clinicas", :nivel 1)
    Tipousuario.create(:nome "secretária", :descricao "Tem total a uma determinada clinica", :nivel 2)
    TipoUsuario.create(:nome "assistente", :descricao "Tem acesso restrito  a uma determinada clínica", :nivel 3)
  end

  def self.down
    drop_table :tipo_usuarios
  end
end
