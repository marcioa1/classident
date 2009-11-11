class CreateTipoPagamentos < ActiveRecord::Migration
  def self.up
    create_table :tipo_pagamentos do |t|
      t.integer :clinica_id
      t.string :nome, :size=>30
      t.integer :ativo

      t.timestamps
    end
    add_index :tipo_pagamentos, :id
    add_index :tipo_pagamentos, :clinica_id
  end

  def self.down
    drop_table :tipo_pagamentos
  end
end
