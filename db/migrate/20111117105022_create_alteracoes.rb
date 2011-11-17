class CreateAlteracoes < ActiveRecord::Migration
  def self.up
    create_table :alteracoes, :force => true do |t|
      t.string    :tabela
      t.integer   :id_liberado
      t.date      :data_correcao
      t.integer   :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :alteracoes
  end
end
