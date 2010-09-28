class CreateClinicas < ActiveRecord::Migration
  def self.up
    create_table :clinicas do |t|
      t.string :nome,  :limit=>20
      t.string :sigla, :limit=>8
      t.boolean :e_administracao

      t.timestamps
    end
    Clinica.create(:nome=>"Administração", :sigla=>"ad", :e_administracao => true)
    Clinica.create(:nome=>"São Cristovão", :sigla=>"sc", :e_administracao => false)
    Clinica.create(:nome=>"Vista Alegre", :sigla=>"va", :e_administracao => false)
    Clinica.create(:nome=>"Vicente de Carvalho", :sigla=>"vc", :e_administracao => false)
    Clinica.create(:nome=>"Recreio", :sigla=>"recreio", :e_administracao => false)
    Clinica.create(:nome=>"Taquara", :sigla=>"taqua", :e_administracao => false)
    # add_column :users, /:clinica_id, :integer
  end

  def self.down
    # remove_column :users, :clinica_id
    drop_table :clinicas
  end
end
