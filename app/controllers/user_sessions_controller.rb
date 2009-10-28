class UserSessionsController < ApplicationController
   before_filter :require_user, :only => :destroy

    def new
      @user_session = UserSession.new
    end
    
    def create
      @user_session = UserSession.new(params[:user_session])
      if @user_session.save
        flash[:notice] = "Login successful!"
        find_carrinho
        redirect_to vitrine_vitrines_path
      else
        flash[:error] = " Usuário não encontrato. Por favro verifique email e senha."
        redirect_to new_user_sessions_path 
      end
    end

    def destroy
      current_user_session.destroy
      session[:carrinho] = nil
      flash[:notice] = "Obrigado pela visita !"
      redirect_to vitrine_vitrines_path
    end
end
