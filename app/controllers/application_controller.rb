# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user
  before_filter :administracao
  before_filter :busca_clinica_atual, :busca_clinicas
  

  def quinzena
    ano = Date.today.year
    mes = Date.today.month
    dia = Date.today.day
    if dia < 16
      @data_inicial = Date.new(ano,mes,1)
      @data_final   = Date.new(ano,mes,15)
    else
      @data_inicial = Date.new(ano,mes,16)
      @data_final   = Date.new(ano,mes,1) + 1.month - 1.day
    end
  end
  
  def verifica_se_tem_senha
    if params[:action]
      session[:senha]          = Senha.senha_cadastrada(
                                    session[:action],
                                    session[:clinica_id]) 
      session[:senha_digitada] = nil if session[:senha].nil?
    else
      session[:senha]          = nil
      session[:senha_digitada] = nil
    end
    @senha = session[:senha]
    if params[:action] && params[:controller]
      @esta_dentro = (params[:controller] + ',' + params[:action] == session[:action_name])
    else
      @esta_dentro = false
    end  
    
    @action         = session[:action]
    @senha          = session[:senha]
    @senha_digitada = session[:senha_digitada]
  end
  
  def salva_action_na_session
    session[:action] = params[:controller]+','+params[:action]
  end 
  
  def administracao
    @clinica_atual = Clinica.find session[:clinica_id].to_i if session[:clinica_id]
  end

  def administracao?
    session[:clinica_id].to_i == Clinica::ADMINISTRACAO_ID
  end
  
  def primeiro_dia_do_mes
    Date.new(Date.today.year, Date.today.month, 1)
  end
  
  def na_quinzena?(data)
    primeira = Date.new(Date.today.year,Date.today.month,1)
    segunda  = Date.new(Date.today.year,Date.today.month,16)
    if Date.today >= segunda
      data < segunda ? false : true
    else
      data < primeira ? false : true
    end
  end
  

  def verify_existence_of_directory
    directory_name = Dir::pwd + "/impressoes/#{session[:clinica_id]}"
    if FileTest::directory?(directory_name)
      return
    else
      Dir::mkdir(directory_name)
    end
  end


  private
  
    def require_master_user
      unless current_user && current_user.master?
        store_location
        flash[:notice] = "Você precisa estar logado como usuário 'master' para ter acesso à esta página."
        redirect_to new_user_sessions_url
        return false
      end
    end
    
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
    
    def busca_clinica_atual
      if current_user && session[:clinica_id]
        if !session[:clinica_id]
          session[:clinica_id] = current_user.clinicas.first.id
        end
        @clinica_atual = Clinica.busca_clinica(session[:clinica_id])
      end
    end

    def busca_clinicas
      @clinicas = []
      if !Rails.cache.read(Clinica::ADMINISTRACAO_ID.to_s)
        Clinica.all.each do |clinica|
          @clinicas << clinica
          Rails.cache.write("clinica_#{clinica.id}",clinica, :expires_in => 14.hours) 
        end
      else
        (1..Clinica::NUMERO_DE_CLINICAS).each { |ind| clinicas << Rails.cache.read("clinica_#{ind}") }
      end
      @clinicas
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

