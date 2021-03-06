class CreateTabelas < ActiveRecord::Migration
  def self.up
    create_table :tabelas do |t|
      t.string :nome,   :limit=>30
      t.boolean :ativa, :default => true
      t.timestamps
    end
    add_index :tabelas, :id
    # Tabela.create!(:id=>1, :nome=>'Inexistente', :clinica_id=>0, :sequencial=>0,:ativa=>false)
  end

  def self.down
    drop_table :tabelas
  end
end
