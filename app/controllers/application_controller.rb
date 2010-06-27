# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user
  before_filter :busca_clinicas

  def quinze_dias
    begin
      @data_inicial = params[:datepicker].to_date
    rescue 
      @data_inicial = Date.today - 15.days
    end
    begin
      @data_final = params[:datepicker2].to_date
    rescue
      @data_final = Date.today
    end
  end
  
  # def @administracao
  #     session[:clinica_id].to_i == 10
  #   end
  
  def administracao
    @adminitracao = session[:clinica_id].to_i == 10
  end
  
  def primeiro_dia_do_mes
    Date.new(Date.today.year, Date.today.month, 1)
  end
  
  private
  
    def require_user
      unless current_user 
        store_location
        flash[:notice] = "Você precisa estar logado para ter acesso à esta página."
        redirect_to new_user_sessions_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "Você precisa estar logado para ter acesso à esta página."
          redirect_to new_user_sessions_path()
        return false
      end
    end

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user 
    end
    
    def store_location
      session[:return_to] = request.request_uri
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
    
    
    def busca_clinicas
      @as_clinicas = Clinica.all(:order=>:nome).collect{|obj| [obj.nome,obj.id]}
      if !session[:clinica_id].nil?
        @clinica_atual = Clinica.find(session[:clinica_id]) 
      end
      @administracao = session[:clinica_id] == 10
    end
    
    def verifica_horario_de_trabalho
      return true if current_user.master?
      if !current_user.horario_de_trabalho?
        current_user_session.destroy
        flash[:notice] = "Volte no seu horário de trabalho !"
        redirect_to root_path
      end
    end
    
    
end
#TODO usar this no jquery
#TODO retornar livro caixa se lançar anterior ao dia do fluxo