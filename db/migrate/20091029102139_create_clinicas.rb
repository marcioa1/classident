class CreateClinicas < ActiveRecord::Migration
  def self.up
    create_table :clinicas do |t|
      t.string :nome
      t.string :sigla
      t.boolean :e_administracao

      t.timestamps
    end
    Clinica.create(:nome=>"São Cristovão", :sigla=>"sc", :e_administracao => true)
    Clinica.create(:nome=>"Centro", :sigla=>"centro", :e_administracao => true)
    Clinica.create(:nome=>"Vista Alegre", :sigla=>"va", :e_administracao => true)
    Clinica.create(:nome=>"Vicente de Carvalho", :sigla=>"vc", :e_administracao => true)
    Clinica.create(:nome=>"Recreio", :sigla=>"recreio", :e_administracao => true)
    Clinica.create(:nome=>"Barra da Tijuca", :sigla=>"barra", :e_administracao => true)
    Clinica.create(:nome=>"Copacabana", :sigla=>"copa", :e_administracao => true)
    Clinica.create(:nome=>"Niterói", :sigla=>"niteroi", :e_administracao => true)
    Clinica.create(:nome=>"Taquara", :sigla=>"taqua", :e_administracao => true)
    Clinica.create(:nome=>"Administração", :sigla=>"ad", :e_administracao => true)
    add_column :users, :clinica_id, :integer
    add_index :clinicas, :id
  end

  def self.down
    remove_column :users, :clinica_id
    drop_table :clinicas
  end
end
