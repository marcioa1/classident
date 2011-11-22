class AddArquivoMortoToPacientes < ActiveRecord::Migration
  def self.up
    add_column :pacientes, :arquivo_morto, :boolean
    add_column :pacientes, :descricao_arquivo_morto, :string
  end

  def self.down
    remove_column :pacientes, :descricao_arquivo_morto
    remove_column :pacientes, :arquivo_morto
  end
end