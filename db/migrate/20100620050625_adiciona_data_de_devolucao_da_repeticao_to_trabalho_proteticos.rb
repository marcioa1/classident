class AdicionaDataDeDevolucaoDaRepeticaoToTrabalhoProteticos < ActiveRecord::Migration
  def self.up
    add_column :trabalho_proteticos, :data_de_devolucao_da_repeticao, :date
  end

  def self.down
    remove_column :trabalho_proteticos, :data_de_devolucao_da_repeticao
  end
end