class CreateBancos < ActiveRecord::Migration
  def self.up
    create_table :bancos do |t|
      t.integer :numero
      t.string  :nome,    :limit => 25

      t.timestamps
    end
    
    Banco.create (:nome=>'Meridional', :numero=> 8)
    Banco.create (:nome=>'Banco do Brasil', :numero=> 1)
    Banco.create (:nome=>'Banerj', :numero=>29)
    Banco.create (:nome=>'Caixa Economica', :numero=>104)
    Banco.create (:nome=>'Bandeirantes', :numero=> 230)
    Banco.create (:nome=>'Bradesco', :numero=>237)
    Banco.create (:nome=>'Real', :numero=> 275)
    Banco.create (:nome=>'Itau', :numero=> 341)
    Banco.create (:nome=>'Mercantil S.P', :numero=>392)
    Banco.create (:nome=>'Unibanco', :numero=> 409)
    Banco.create (:nome=>'Sudameris', :numero=>447)
    Banco.create (:nome=>'HSBC', :numero=> 399)
    Banco.create (:nome=>'Sudameris', :numero=> 347)
    Banco.create (:nome=>'Citibank', :numero=> 745)
    Banco.create (:nome=>'BCN', :numero=> 291)
    Banco.create (:nome=>'Santander', :numero=>353)
    Banco.create (:nome=>'BBVA', :numero=> 641)
    Banco.create (:nome=>'Bancoob', :numero=> 756)
    Banco.create (:nome=>'Banrisul', :numero=> 41)
    Banco.create (:nome=>'mercantil do brasil', :numero=> 389)
    Banco.create (:nome=>'santander', :numero=> 424)
    Banco.create (:nome=>'BANESPA', :numero=> 33)
    Banco.create (:nome=>'UNICRED', :numero=> 748)
    Banco.create (:nome=>'BANKBOSTON', :numero=> 479)
    Banco.create (:nome=>'BRB', :numero=> 70)
    Banco.create (:nome=>'SAFRA', :numero=> 422)
    Banco.create (:nome=>'BANESTES', :numero=> 21)
    Banco.create (:nome=>'BESC', :numero=> 27)
    Banco.create (:nome=>'Real', :numero=> 356)

  end

  def self.down
    drop_table :bancos
  end
end
