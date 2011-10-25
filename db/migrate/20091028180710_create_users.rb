class CreateUsers < ActiveRecord::Migration
  def self.up
   create_table :users do |t|
     t.string    :login,               :null => false                # optional, you can use email instead, or both
     t.string    :email,               :null => false                # optional, you can use login instead, or both
     t.string    :crypted_password,    :null => false                # optional, see below
     t.string    :password_salt,       :null => false                # optional, but highly recommended
     t.string    :persistence_token,   :null => false                # required
     t.integer   :login_count,         :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
     t.integer   :failed_login_count,  :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
     t.datetime  :last_request_at                                    # optional, see Authlogic::Session::MagicColumns
     t.datetime  :current_login_at                                   # optional, see Authlogic::Session::MagicColumns
     t.datetime  :last_login_at                                      # optional, see Authlogic::Session::MagicColumns
     t.string    :current_login_ip                                   # optional, see Authlogic::Session::MagicColumns
     t.string    :last_login_ip                                      # optional, see Authlogic::Session::MagicColumns
     t.references :tipo_usuario
     t.string    :nome, :limit => 60
     t.timestamps
   end
   User.create!(:login => 'ricardo', :password=>'1234', :email=>'classident@ibest.com.br',
    :password_confirmation =>'1234', :nome=>'Ricardo', :tipo_usuario_id => 1, :clinicas => Clinica.all)
   User.create!(:login => 'fabiana', :password=>'1234', :email=>'fabi@ibest.com.br',
    :password_confirmation =>'1234', :nome=>'Fabiana Felix', :tipo_usuario_id => 2, :clinicas => Clinica.all)
   User.create!(:login => 'regina', :password=>'1234', :email=>'regina@ibest.com.br',
    :password_confirmation =>'1234', :nome=>'Regina', :tipo_usuario_id => 2, :clinicas => Clinica.all)
   User.create!(:login => 'anapaula', :password=>'1234', :email=>'anapaula@ibest.com.br',
             :password_confirmation =>'1234', :nome=>'Ana Paula', :tipo_usuario_id => 2, :clinicas => Clinica.all)
    User.create!(:login => 'margareth', :password=>'1234', :email=>'margo@ibest.com.br', 
    :password_confirmation =>'1234', :nome=>'Margareth', :tipo_usuario_id => 3, :clinicas =>[ Clinica.find_by_sigla("SC")])
   User.create!(:login => 'cristina', :password=>'1234', :email=>'cristina@ibest.com.br',
    :password_confirmation =>'1234', :nome=>'Izabel Cristina', :tipo_usuario_id => 3, :clinicas => [Clinica.find_by_sigla("VC")])
   User.create!(:login => 'shirlene', :password=>'1234', :email=>'shirlene@ibest.com.br',
             :password_confirmation =>'1234', :nome=>'Shirlene Krasnowolski', :tipo_usuario_id => 3, :clinicas => [Clinica.find_by_sigla("VC")])
   User.create!(:login => 'lindalva', :password=>'1234', :email=>'lindalva@ibest.com.br',
    :password_confirmation =>'1234', :nome=>'Lindalva', :tipo_usuario_id => 3, :clinicas => [Clinica.find_by_sigla("taqua")])
   User.create!(:login => 'celia', :password=>'1234', :email=>'celia@ibest.com.br',
    :password_confirmation =>'1234', :nome=>'Celia Silva', :tipo_usuario_id => 3, :clinicas => [Clinica.find_by_sigla("taqua")])
   User.create!(:login => 'silvia', :password=>'1234', :email=>'silvia@ibest.com.br',
    :password_confirmation =>'1234', :nome=>'Silvia', :tipo_usuario_id => 3, :clinicas => [Clinica.find_by_sigla("va")])
   User.create!(:login => 'keyth', :password=>'1234', :email=>'keyth@ibest.com.br',
    :password_confirmation =>'1234', :nome=>'Keyth', :tipo_usuario_id => 3, :clinicas => [Clinica.find_by_sigla("centro")])
   User.create!(:login => 'thuani', :password=>'1234', :email=>'thuani@ibest.com.br',
    :password_confirmation =>'1234', :nome=>'Thuani', :tipo_usuario_id => 3, :clinicas => [Clinica.find_by_sigla("centro")])
   User.create!(:login => 'sheyla', :password=>'1234', :email=>'sheyla@ibest.com.br',
             :password_confirmation =>'1234', :nome=>'Sheyla', :tipo_usuario_id => 3, :clinicas => [Clinica.find_by_sigla("recreio")])
   User.create!(:login => 'angela', :password=>'1234', :email=>'angela@ibest.com.br',
             :password_confirmation =>'1234', :nome=>'Angela', :tipo_usuario_id => 3, :clinicas => [Clinica.find_by_sigla("vc")])
   User.create!(:login => 'paty', :password=>'1234', :email=>'paty@ibest.com.br',
             :password_confirmation =>'1234', :nome=>'Patricia', :tipo_usuario_id => 3, :clinicas => [Clinica.find_by_sigla("sc")])

  end

  def self.down
   drop_table :users
  end
end
