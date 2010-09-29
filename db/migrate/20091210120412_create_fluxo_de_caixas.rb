class CreateFluxoDeCaixas < ActiveRecord::Migration
  def self.up
    create_table :fluxo_de_caixas do |t|
      t.references :clinica
      t.date       :data
      t.decimal    :saldo_em_dinheiro, :precision=>9, :scale=>2
      t.decimal    :saldo_em_cheque, :precision=>9, :scale=>2   
      
      t.timestamps
    end
  end

  def self.down
    drop_table :fluxo_de_caixas
  end
end
