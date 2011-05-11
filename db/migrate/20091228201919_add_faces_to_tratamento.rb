class AddFacesToTratamento < ActiveRecord::Migration
  def self.up
    add_column :tratamentos, :mesial, :boolean
    add_column :tratamentos, :oclusal, :boolean
    add_column :tratamentos, :distal, :boolean
    add_column :tratamentos, :palatina, :boolean
  end

  def self.down
    remoce_column :tratamentos, :palatina
    remove_column :tratamentos, :distal
    remove_column :tratamentos, :oclusal
    remove_column :tratamentos, :mesial
  end
end
