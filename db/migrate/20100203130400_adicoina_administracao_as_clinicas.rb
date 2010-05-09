class AdicoinaAdministracaoAsClinicas < ActiveRecord::Migration
  def self.up
    add_column :clinicas, :e_administracao, :boolean
    Clinica.all.each do |cl|
      cl.e_administracao = (cl.sigla=="ad")
      cl.save
    end
  end

  def self.down
    remove_column :clinicas, :e_administracao
  end
end
