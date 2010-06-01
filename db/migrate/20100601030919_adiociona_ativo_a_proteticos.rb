class AdiocionaAtivoAProteticos < ActiveRecord::Migration
  def self.up
    add_column :proteticos, :ativo, :boolean, :default => true
    Protetico.all.each do |pro|
      pro.ativo = true
      pro.save
    end
  end

  def self.down
    remove_column :proteticos, :ativo
  end
end