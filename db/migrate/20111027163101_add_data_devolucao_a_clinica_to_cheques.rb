class AddDataDevolucaoAClinicaToCheques < ActiveRecord::Migration
  def self.up
    add_column :cheques, :data_envio_a_clinica, :date
    add_column :cheques, :data_recebido_da_administracao, :date
  end

  def self.down
    remove_column :cheques, :data_recebido_da_administracao
    remove_column :cheques, :data_envio_a_clinica
  end
end