class AddFacesQueFaltamToOdontograma < ActiveRecord::Migration
  def self.up
    add_column :tratamentos, :vestibular, :boolean
    add_column :tratamentos, :lingual, :boolean
    add_column :tratamentos, :estado, :string, :limit => 30
  end

  def self.down
    remove_column :tratamentos, :estado
    remove_column :tratamentos, :lingual
    remove_column :tratamentos, :vestibular
  end
end
