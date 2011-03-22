class CreateCheques < ActiveRecord::Migration
  def self.up
    create_table :cheques do |t|
      t.references :banco
      # t.integer :numero_do_banco
      t.string :agencia, :limit => 10
      t.string :conta_corrente, :limit => 10
      t.string :numero, :limit => 12
      t.decimal :valor, :precision=>9, :scale=>2
      t.references :recebimento
      #TODO decidir se este campo vai ficar. Acho que não, pois chegará pelo recebimento
      t.integer :paciente_id
      t.integer :segundo_paciente
      t.integer :terceiro_paciente
      t.decimal :valor_primeiro_paciente, :precision=>9, :scale=>2
      t.decimal :valor_segundo_paciente, :precision=>9, :scale=>2
      t.decimal :valor_terceiro_paciente, :precision=>9, :scale=>2
      
      t.timestamps
    end
    add_index :cheques, :recebimento_id
  end

  def self.down
    drop_table :cheques
  end
end
