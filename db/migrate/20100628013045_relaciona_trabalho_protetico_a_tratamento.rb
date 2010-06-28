class RelacionaTrabalhoProteticoATratamento < ActiveRecord::Migration
  def self.up
    add_column :trabalho_proteticos, :tratamento_id, :integer
  end

  def self.down
    remove_column :trabalho_proteticos, :tratamento_id
  end
end