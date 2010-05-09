class AddAdminUser < ActiveRecord::Migration
  def self.up
    User.create!(:login => 'ricardo', :password=>'1234', :email=>'classident@ibest.com.br',
     :password_confirmation =>'1234', :nome=>'Ricardo')
  end

  def self.down
    User.find_by_login('ricardo').destroy
  end
end
