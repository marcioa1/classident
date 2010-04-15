class AddSeqToTipoPagamento < ActiveRecord::Migration
  def self.up
    add_column :tipo_pagamentos, :seq, :integer
  end

  def self.down
    remove_column :tipo_pagamentos, :seq
  end
end
