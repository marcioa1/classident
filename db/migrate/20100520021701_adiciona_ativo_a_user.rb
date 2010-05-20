class AdicionaAtivoAUser < ActiveRecord::Migration
  def self.up
    add_column :users, :ativo, :boolean, :default=> true
    User.all.each do |u|
      u.ativo = true
      u.save
    end
  end

  def self.down
    remove_column :users, :ativo
  end
end