class CreateCeps < ActiveRecord::Migration
  def self.up
    create_table :ceps do |t|
       t.string   :logradouro
       t.string   :cep
       t.string   :bairro
       t.string   :cidade
     end
     add_index :ceps, :logradouro  
  end
  
  def self.down
    drop_index :ceps, :logradouro
    drop_table :ceps
  end
end
