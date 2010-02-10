class AdicoinaAdministracaoAsClinicas < ActiveRecord::Migration
  def self.up
    Clinica.create(:nome=>"Administração", :sigla=>"AD")
    add_column :clinicas, :e_administracao, :boolean
    Clinica.all.each do |cl|
      cl.e_administracao = (cl.sigla=="AD")
      cl.save
    end
  end

  def self.down
    remove_column :clinicas, :e_administracao
  end
end
