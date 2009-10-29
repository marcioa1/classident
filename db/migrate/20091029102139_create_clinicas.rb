class CreateClinicas < ActiveRecord::Migration
  def self.up
    create_table :clinicas do |t|
      t.string :nome
      t.string :sigla

      t.timestamps
    end
    Clinica.create(:nome=>"São Cristovão", :sigla=>"SC")
    Clinica.create(:nome=>"Centro", :sigla=>"CE")
    Clinica.create(:nome=>"Vista Alegre", :sigla=>"VA")
    Clinica.create(:nome=>"Vicente de Carvalho", :sigla=>"VC")
    Clinica.create(:nome=>"Recreio", :sigla=>"RE")
    Clinica.create(:nome=>"Barra da Tijuca", :sigla=>"BA")
    Clinica.create(:nome=>"Copacabana", :sigla=>"CO")
    Clinica.create(:nome=>"Niterói", :sigla=>"NI")
    Clinica.create(:nome=>"Taquara", :sigla=>"TA")
    add_column :users, :clinica_id, :integer
    add_index :clinicas, :id
  end

  def self.down
    remove_column :users, :clinica_id
    drop_table :clinicas
  end
end
