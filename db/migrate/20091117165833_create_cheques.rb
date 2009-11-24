class CreateCheques < ActiveRecord::Migration
  def self.up
    create_table :cheques do |t|
      t.integer :banco_id
      t.string :agencia
      t.string :conta_corrente
      t.string :numero
      t.decimal :valor, :precision=>6, :scale=>2
      t.integer :recebimento_id
      #TODO decidir se este campo vai ficar
      t.integer :paciente_id
      t.integer :segundo_paciente
      t.integer :terceiro_paciente
      t.decimal :valor_primeiro_paciente, :precision=>6, :scale=>2
      t.decimal :valor_segundo_paciente, :precision=>6, :scale=>2
      t.decimal :valor_terceiro_paciente, :precision=>6, :scale=>2
      
      t.timestamps
    end
    add_index :cheques, :recebimento_id
  end

  def self.down
    drop_table :cheques
  end
end
