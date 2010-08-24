class CreateSenhas < ActiveRecord::Migration
  def self.up
    create_table :senhas , :id => false do |t|
      t.string     :controller_name
      t.string     :action_name
      t.references :clinica
      t.string     :senha, :maxlength => 5, :allow_blank => false

      t.timestamps
    end
    add_index :senhas, [:controller_name, :action_name], :unique=>true
  end

  def self.down
    remove_index :senhas, :column_name
    drop_table :senhas
  end
end
