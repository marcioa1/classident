class AddLiberadoParaPagamentoToTrabalhoProtetico < ActiveRecord::Migration
  def self.up
    add_column :trabalho_proteticos, :data_liberacao_para_pagamento, :datetime, :null => true
  end

  def self.down
    remove_column :trabalho_proteticos, :data_liberacao_para_pagamento
  end
end