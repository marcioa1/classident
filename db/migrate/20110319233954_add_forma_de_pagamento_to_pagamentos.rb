class AddFormaDePagamentoToPagamentos < ActiveRecord::Migration
  def self.up
    add_column :pagamentos, :forma_de_pagamento, :string
  end

  def self.down
    remove_column :pagamentos, :forma_de_pagamento
  end
end