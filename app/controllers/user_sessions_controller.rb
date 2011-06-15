class UserSessionsController < ApplicationController

   layout "login"
   before_filter :require_user, :only => :destroy

    def new
      @user_session = UserSession.new
    end
    
    def create
      # reset_session
      @user_session = UserSession.new(params[:user_session])
      if @user_session.save
        user         = User.find_by_login(@user_session.login)
        if user.clinicas.empty?
          flash[:error] = " Usuário sem clínica associada. Entre em contato com a administração e peça para associar uma clínica para você."
          redirect_to new_user_sessions_path 
        else
          current_user = user
          expire_fragment "cabecalho_#{current_user.id}"
          if current_user.clinicas.map(&:id).include?(Clinica::ADMINISTRACAO_ID)
            session[:clinica_id] = Clinica::ADMINISTRACAO_ID
          else
            session[:clinica_id] = current_user.clinicas.first.id
            Debito.verifica_debitos_de_ortodontia(session[:clinica_id]) unless @clinica_atual.administracao?
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
#MAAM2849

# senha maumau JoaoPE15