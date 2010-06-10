class UserSessionsController < ApplicationController

   layout "login"
   before_filter :require_user, :only => :destroy

    def new
      @user_session = UserSession.new
    end
    
    def create
      reset_session
      @user_session = UserSession.new(params[:user_session])
      if @user_session.save
        if current_user.password == "1234"
          redirect_to troca_senha_user_path
        else
          debugger
          if current_user.clinicas.map(&:id).include?(Clinica::ADMINISTRACAO_ID)
            session[:clinica_id] = Clinica::ADMINISTRACAO_ID
          else
            session[:clinica_id] = current_user.clinicas.first.id
          end
          redirect_to pesquisa_pacientes_path
        end
      else
        flash[:error] = " Usuário não encontrado. Por favor verifique usuário, senha e dias e horários permitidos."
        redirect_to new_user_sessions_path 
      end
    end

    def destroy
      current_user_session.destroy
      flash[:notice] = "Obrigado pela visita !"
      redirect_to root_path
    end
    
    
end
#MAAMI35
#MAAM2849

#TEHOSPEDO   th33407   o3X8hPAas9

# senha maumau JoaoPE15