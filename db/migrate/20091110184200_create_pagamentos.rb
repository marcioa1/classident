class CreatePagamentos < ActiveRecord::Migration
  def self.up
    create_table :pagamentos do |t|
      t.references    :clinica
      t.references    :tipo_pagamento
      t.date          :data_de_vencimento
      t.date          :data_de_pagamento
      t.decimal       :valor, :precision=>9, :scale=>2, :default => 0
      t.decimal       :valor_pago, :precision=>9, :scale=>2, :default => 0
      t.string        :observacao, :limit => 50
      t.boolean       :nao_lancar_no_livro_caixa, :default => false
      t.datetime      :data_de_exclusao

      t.timestamps
    end
  end

  def self.down
    drop_table :pagamentos
  end
end
