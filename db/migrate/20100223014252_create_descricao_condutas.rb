class CreateDescricaoCondutas < ActiveRecord::Migration
  def self.up
    create_table :descricao_condutas do |t|
      t.text :descricao
      t.timestamps
    end
    add_column :item_tabelas, :descricao_conduta_id, :integer
  end

  def self.down
    remove_column :item_tabelas, :descricao_conduta_id
    drop_table :descricao_condutas
  end
end
