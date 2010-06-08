class AdicionaHoraAUser < ActiveRecord::Migration
  def self.up
    add_column :users, :hora_de_inicio, :string
    add_column :users, :hora_de_termino, :string
  end

  def self.down
    remove_column :users, :hora_de_termino
    remove_column :users, :hora_de_inicio
  end
end