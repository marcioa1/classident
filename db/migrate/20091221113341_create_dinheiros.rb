class CreateDinheiros < ActiveRecord::Migration
  def self.up
    create_table :dinheiros do |t|
      t.date :data
      t.decimal :valor, :precision=>8, :scale=>2
      t.string :descricao, :size=>40
      t.timestamps
    end
    add_index :dinheiros, :data
    add_index :dinheiros, :id
  end

  def self.down
    drop_table :dinheiros
  end
end
