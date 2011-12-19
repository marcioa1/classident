class CreateAcompanhamentoCheques < ActiveRecord::Migration
  def self.up
    create_table :acompanhamento_cheques do |t|
      t.references :cheque
      t.string     :origem, :limit=>1, :default => 'C'
      t.string     :descricao
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :acompanhamento_cheques
  end
end
