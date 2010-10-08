class AddProfissaoToPaciente < ActiveRecord::Migration
  def self.up
    add_column :pacientes, :profissao, :string, :limit => 50
  end

  def self.down
    remove_column :pacientes, :profissao
  end
end