class CreateTipoUsuarios < ActiveRecord::Migration
  def self.up
    create_table :tipo_usuarios do |t|
      t.string  :nome,      :limit => 12 
      t.string  :descricao, :limit => 40
      t.integer :nivel,     :default => 4

      t.timestamps
    end
    add_index :tipo_usuarios, :id
    TipoUsuario.create(:nome =>"master", :descricao=> "Tem total acesso as rotias rotinas do sistema", :nivel=> 0)
    TipoUsuario.create(:nome =>"administração", :descricao=> "Tem total ao modulo de administracao e às clinicas", :nivel=> 1)
    TipoUsuario.create(:nome =>"secretária", :descricao =>"Tem total a uma determinada clinica", :nivel=> 2)
    TipoUsuario.create(:nome =>"assistente", :descricao =>"Tem acesso restrito a uma determinada clínica", :nivel=> 3)
  end

  def self.down
    drop_table :tipo_usuarios
  end
end
