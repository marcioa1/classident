class UserSessionsController < ApplicationController

  layout "login"
   before_filter :require_user, :only => :destroy

    def new
      @user_session = UserSession.new
    end
    
    def create
      @user_session = UserSession.new(params[:user_session])
      if @user_session.save
        flash[:notice] = "Login successful!"
        if current_user.password == "1234"
          redirect_to troca_senha_user_path
        else
          if current_user.clinica.nil?
            session[:clinica] = "Administração"
            session[:clinica_id] = 0
          else
            session[:clinica] = current_user.clinica.nome
            session[:clinica_id] = current_user.clinica.id
          end
          redirect_to tabelas_path
        end
      else
        flash[:error] = " Usuário não encontrato. Por favor verifique email e senha."
        redirect_to new_user_sessions_path 
      end
    end

    def destroy
      current_user_session.destroy
      session[:carrinho] = nil
      flash[:notice] = "Obrigado pela visita !"
      redirect_to root_path
    end
    
    
end
#MAAMI35
#MAAM2849

#TEHOSPEDO   th33407   o3X8hPAas9

# senha maumau JoaoPE15