class ChangeSenhasTable < ActiveRecord::Migration
  def self.up
    change_table :senhas do |t|
      t.remove :controller_name, :action_name
      t.string :action
    end
  end

  def self.down
    change_table :senhas do |t|
      t.remove :action
      t.string :controller_name, :action_name
    end
  end
end
