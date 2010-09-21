# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user
  before_filter :busca_clinica_atual
  before_filter :administracao
  

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
      session[:senha] = Senha.senha(params[:controller], params[:action], session[:clinica_id])
      session[:senha_digitada] = nil if session[:senha].nil?
    else
      session[:senha]          = nil
      session[:senha_digitada] = nil
    end
    @action         = session[:action]
    @senha          = session[:senha]
    @senha_digitada = session[:senha_digitada]
  end
  
  def salva_action_na_session
    session[:action] = params[:controller]+','+params[:action]
  end 
  
  
  # def @administracao
  #     session[:clinica_id].to_i == 10
  #   end
  
  def administracao
    @administracao = session[:clinica_id].to_i == Clinica::ADMINISTRACAO_ID
  end
  
  def primeiro_dia_do_mes
    Date.new(Date.today.year, Date.today.month, 1)
  end
  
  def na_quinzena?(data)
    primeira = Date.new(Date.today.year,Date.today.month,1)
    segunda  = Date.new(Date.today.year,Date.today.month,16)
    return false if data < primeira
    return false if data < segunda && Date.today >= segunda
    return true if data < segunda && Date.today < segunda
    return true if data >= segunda && Date.today >= segunda
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
    
    def busca_clinica_atual
      @clinica_atual = Clinica.find(session[:clinica_id]) if session[:clinica_id].present?
    end

    def busca_clinicas
      clinicas = []
      if !Rails.cache.read(Clinica::ADMINISTRACAO_ID.to_s)
        Clinica.all.each do |clinica|
          clinicas << clinica
          Rails.cache.write("clinica_#{clinica.id}",clinica, :expires_in => 14.hours) 
        end
      else
        (1..Clinica::NUMERO_DE_CLINICAS).each { |ind| clinicas << Rails.cache.read("clinica_#{ind}") }
      end
      clinicas
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
#TODO ao editar um recebimento commais de um paciente está misturando os pacientes
#FIXME AO salvar um dados d epaciente, atualizar o cache do memcached
#TODO o link de orçamento no aproveitamento de orçamento na adm está errado.

#TODO Consertar Flash messages
#TODO definir tamanho dos campos na tabela senhas e demais tabelas
#TODO Pensar em diminuir o numero de letras digitadas para busca, e até mesmo configurar por usuário.
#TODO Colocar as clinicas no memcached
#TODO dentes para selecionar ao invez de escrever entre vírgulas
#TODO Os dados de endereço não vieram. Verificar esta informação.
#TODO Refazer clinicas em cadastro de usuário

#TODO a seleção de cheques a enviar para a clinica está trazendo até os não selecionados
#TODO o saldo em cheque do fluxo de caixa está muito errado
#TODO aumentar velocidade do site
#TODO Consertar layout do autocomplete ( barra de rolagem)
#TODO colocar plugin de cookies no yml
#TODO link para exclusão de tratamento

