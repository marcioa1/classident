class CreateClinicas < ActiveRecord::Migration
  def self.up
    create_table :clinicas do |t|
      t.string :nome
      t.string :sigla

      t.timestamps
    end
    Clinica.create(:nome=>"São Cristovão", :sigla=>"sc")
    Clinica.create(:nome=>"Centro", :sigla=>"centro")
    Clinica.create(:nome=>"Vista Alegre", :sigla=>"va")
    Clinica.create(:nome=>"Vicente de Carvalho", :sigla=>"vc")
    Clinica.create(:nome=>"Recreio", :sigla=>"recreio")
    Clinica.create(:nome=>"Barra da Tijuca", :sigla=>"barra")
    Clinica.create(:nome=>"Copacabana", :sigla=>"copa")
    Clinica.create(:nome=>"Niterói", :sigla=>"niteroi")
    Clinica.create(:nome=>"Taquara", :sigla=>"taqua")
    Clinica.create(:nome=>"Administração", :sigla=>"adm")
    add_column :users, :clinica_id, :integer
    add_index :clinicas, :id
  end

  def self.down
    remove_column :users, :clinica_id
    drop_table :clinicas
  end
end
