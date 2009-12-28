class AddFacesToTratamento < ActiveRecord::Migration
  def self.up
    add_column :tratamentos, :mesial, :boolean
    add_column :tratamentos, :oclusal, :boolean
    add_column :tratamentos, :distal, :boolean
  end

  def self.down
    remove_column :tratamentos, :distal
    remove_column :tratamentos, :oclusal
    remove_column :tratamentos, :mesial
  end
end
