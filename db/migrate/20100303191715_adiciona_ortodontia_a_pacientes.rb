class AdicionaOrtodontiaAPacientes < ActiveRecord::Migration
  def self.up
    add_column :pacientes, :ortodontia, :boolean
    add_column :pacientes, :ortodontista_id, :integer
    add_column :pacientes, :mensalidade_de_ortodontia, :decimal, :precision=>9, :scale=>2
    add_column :pacientes, :sair_da_lista_de_debitos, :boolean
    add_column :pacientes, :motivo_sair_da_lista_de_debitos, :string, :limit => 30
    add_column :pacientes, :data_da_saida_da_lista_de_debitos, :date
    add_column :pacientes, :data_da_suspensao_da_cobranca_de_orto, :date
    add_column :pacientes, :motivo_suspensao_cobranca_orto, :string, :limit => 30
    add_column :dentistas, :ortodontista, :boolean, :default=>false
  end

  def self.down
    remove_column :dentistas, :ortodontista
    remove_column :pacientes, :motivo_suspensao_cobranca_orto
    remove_column :pacientes, :data_da_suspensao_da_cobranca_de_orto
    remove_column :pacientes, :data_da_saida_da_lista_de_debitos
    remove_column :pacientes, :motivo_sair_da_lista_de_debitos
    remove_column :pacientes, :sair_da_lista_de_debitos
    remove_column :pacientes, :mensalidade_de_ortodontia
    remove_column :pacientes, :ortodontista_id
    remove_column :pacientes, :ortodontia
  end
end
