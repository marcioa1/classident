class CreateClinicas < ActiveRecord::Migration
  def self.up
    create_table :clinicas do |t|
      t.string :nome,  :limit=>20
      t.string :sigla, :limit=>8
      t.boolean :administracao, :default=>false

      t.timestamps
    end
    Clinica.create(:nome=>"Administração", :sigla=>"ad", :administracao => true)
    Clinica.create(:nome=>"São Cristovão", :sigla=>"sc", :administracao => false)
    Clinica.create(:nome=>"Vista Alegre", :sigla=>"va", :administracao => false)
    Clinica.create(:nome=>"Vicente de Carvalho", :sigla=>"vc", :administracao => false)
    Clinica.create(:nome=>"Recreio", :sigla=>"recreio", :administracao => false)
    Clinica.create(:nome=>"Taquara", :sigla=>"taqua", :administracao => false)
    Clinica.create(:nome=>"Centro", :sigla=>"centro", :administracao => false)
    # add_column :users, /:clinica_id, :integer
  end

  def self.down
    # removcolumn :users, :clinica_id
    drop_table :clinicas
  end
end
