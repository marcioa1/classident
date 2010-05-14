class CreateOrcamentos < ActiveRecord::Migration
  def self.up
    create_table :orcamentos do |t|
      t.references :paciente
      t.integer :numero
      t.date :data
      t.references :dentista
      t.decimal :desconto, :precision=>9 , :scale=>2
      t.decimal :valor, :precision=>9 , :scale=>2
      t.decimal :valor_com_desconto, :precision=>9 , :scale=>2
      t.string :forma_de_pagamento
      t.integer :numero_de_parcelas
      t.date :vencimento_primeira_parcela
      t.decimal :valor_da_parcela, :precision=>9 , :scale=>2
      t.date :data_de_inicio
      t.timestamps
    end
  end

  def self.down
    drop_table :orcamentos
  end
end
