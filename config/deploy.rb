###### START DEPLOY.RB ######

# Your cPanel/SSH login name

set :user , "root"
# set :user, "anadatac"


# The domain name of the server to deploy to, this can be your domain or the domain of the server.

set :server_name , "68.233.11.17"


# Your svn / git login name

set :scm_username , "marcioa1"

set :scm_password, Proc.new { CLI.password_prompt "GIT Password: "}


set :keep_releases, 3

# Your repository type, by default we use subversion. 

#set :scm, :subversion



# If you are using git, uncomment the following line and comment out the line above.

set :scm, :git



# The name of your application, this will also be the folder were your application 

# will be deployed to

set :application, "classident"



# the url for your repository

set :repository, "git://github.com/marcioa1/classident.git"



###### There is no need to edit anything below this line ######

set :deploy_to, "/home/anadata/domains/classident.anadata.com.br/classident"

set :use_sudo, false

set :group_writable, false

set :keep_releases, 3

default_run_options[:pty] = true 



role :app, server_name

role :web, server_name

role :db,  server_name, :primary => true



# set the proper permission of the public folder

task :after_update_code, :roles => [:web, :db, :app] do

  run "chown anadata.anadata #{release_path} -R"
  run "chmod 755 #{release_path}/public"

end



namespace :deploy do

  desc "restart passenger"

  task :restart do

    passenger::restart

  end

   

end



namespace :passenger do

  desc "Restart dispatchers"

  task :restart do

    run "touch #{current_path}/tmp/restart.txt"

  end

end



###### END DEPLOY.RB ######