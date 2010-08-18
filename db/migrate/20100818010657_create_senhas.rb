class CreateSenhas < ActiveRecord::Migration
  def self.up
    create_table :senhas , :id => false do |t|
      t.string     :controller
      t.string     :action
      t.references :clinica
      t.string     :senha, :maxlength => 5, :allow_blank => false

      t.timestamps
    end
  end

  def self.down
    drop_table :senhas
  end
end
