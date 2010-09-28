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
   User.create!(:login => 'margareth', :password=>'1234', :email=>'margo@ibest.com.br',
    :password_confirmation =>'1234', :nome=>'Margareth', :tipo_usuario_id => 3, :clinicas =>[ Clinica.find_by_sigla("SC")])
   User.create!(:login => 'cristina', :password=>'1234', :email=>'critina@ibest.com.br',
    :password_confirmation =>'1234', :nome=>'Izabel Cristina', :tipo_usuario_id => 3, :clinicas => [Clinica.find_by_sigla("VC")])
   
  end

  def self.down
   drop_table :users
  end
end
