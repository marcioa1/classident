class CreateSenhas < ActiveRecord::Migration
  def self.up
    create_table :senhas do |t|
      t.string     :controller_name, :limit => 45
      t.string     :action_name, :limit => 45
      t.references :clinica
      t.string     :senha, :maxlength => 5, :allow_blank => false

      t.timestamps
    end
    add_index :senhas, [:controller_name, :action_name], :unique=>true
  end

  def self.down
    drop_table :senhas
  end
end
