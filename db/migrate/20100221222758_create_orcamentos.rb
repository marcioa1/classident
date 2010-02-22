class CreateOrcamentos < ActiveRecord::Migration
  def self.up
    create_table :orcamentos do |t|
      t.references :paciente
      t.integer :numero
      t.date :data
      t.references :dentista
      t.decimal :desconto
      t.decimal :valor
      t.decimal :valor_com_desconto
      t.string :forma_de_pagamento
      t.integer :numero_de_parcelas
      t.date :vencimento_primeira_parcela
      t.decimal :valor_da_parcela
      t.date :data_de_inicio
      t.timestamps
    end
  end

  def self.down
    drop_table :orcamentos
  end
end
