class AddDataRecebimentoAdm < ActiveRecord::Migration
  def self.up
    add_column :cheques, :data_recebimento_na_administracao, :date
  end

  def self.down
    remove_column :cheques, :data_recebimento_na_administracao
  end
end
