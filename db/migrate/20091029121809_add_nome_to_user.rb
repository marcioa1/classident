class AddNomeToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :nome, :string
    add_column :users, :ativo, :boolean, :default=>true
  end

  def self.down
    remove_column :users, :ativo
    remove_column :users, :nome
  end
end
