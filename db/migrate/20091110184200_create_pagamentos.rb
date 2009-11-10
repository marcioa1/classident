class CreatePagamentos < ActiveRecord::Migration
  def self.up
    create_table :pagamentos do |t|
      t.integer :clinica_id
      t.integer :tipo_pagamento_id
      t.date :data_de_vencimento
      t.date :data_de_pagamento
      t.decimal :valor, :precision=>6, :scale=>2
      t.decimal :valor_pago, :precision=>6, :scale=>2
      t.string :observacao
      t.boolean :nao_lancar_no_livro_caixa, :default=>false
      t.datetime :data_de_exclusao

      t.timestamps
    end
    add_index :pagamentos, :id
    add_index :pagamentos, :clinica_id
  end

  def self.down
    drop_table :pagamentos
  end
end
