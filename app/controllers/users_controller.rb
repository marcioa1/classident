class UsersController < ApplicationController
  
  layout "adm"
  #before_filter :require_no_user#, :only => [:new, :create]
  before_filter :require_user#, :only => [:show, :edit, :update]

  def index
    redirect_to logout_path unless current_user.pode_incluir_user
    @users    = User.ativos.por_nome
    @inativos = User.inativos.por_nome
  end

  def new
    redirect_to users_path unless current_user.pode_incluir_user
    @clinicas      = busca_clinicas
    @user          = User.new
    @tipos_usuario = TipoUsuario.all(:order=>:nome).collect{|obj| [obj.nome,obj.id]}
    if !current_user.master?
       master = TipoUsuario.master.collect{|obj| [obj.nome,obj.id]}
       @tipos_usuario = @tipos_usuario - master
    end
  end

  def create
    @user = User.new(params[:user])
    @user.password = '1234'
    @user.password_confirmation = '1234'
    (1..10).each do |id|
      if params[("clinica_" + id.to_s).to_sym]
        @user.clinicas << Clinica.find(id)
      end
    end
    if @user.save
      flash[:notice] = "Usuário registrado!"
      redirect_back_or_default @user
    else 
       @tipos_usuario = TipoUsuario.all(:order=>:nome).collect{|obj| [obj.nome,obj.id]}
       if !current_user.master?
         master = TipoUsuario.master.collect{|obj| [obj.nome,obj.id]}
         @tipos_usuario = @tipos_usuario - master
		     @clinicas      = busca_clinicas
       end
		     @clinicas      = busca_clinicas
       render :action => :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user     = User.find(params[:id])
    @clinicas = busca_clinicas 
    @tipos_usuario = TipoUsuario.all(:order=>:nome).collect{|obj| [obj.nome,obj.id]}
    if !current_user.master?
       master = TipoUsuario.master.collect{|obj| [obj.nome,obj.id]}
       @tipos_usuario = @tipos_usuario - master
    end
  end

  def update
    @user = User.find(params[:id])
    @user.clinicas = []
    (1..10).each do |id|
      if params[("clinica_" + id.to_s).to_sym]
        @user.clinicas << Clinica.find(id)
      end
    end
    if @user.update_attributes(params[:user])
      flash[:notice] = "Usuário alterado!"
      redirect_to users_path
    else
       @clinicas = busca_clinicas 
       @tipos_usuario = TipoUsuario.all(:order=>:nome).collect{|obj| [obj.nome,obj.id]}
       @tipos_usuario = @tipos_usuario - TipoUsuario.master if !current_user.master?
      render :action => :edit
    end
  end
  
  def troca_senha
    @user          = current_user
    @user.password = ""
  end
  
  def salva_nova_senha
    @user = User.find(params[:id])   
    if params[:password]  == params[:password_confirmation]
      @user.update_attribute('password', params[:password_confirmation])
      current_user = @user
      redirect_to pesquisa_pacientes_path
    else
      flash[:error] = "senhas não conferem"
      render troca_senha
    end
  end
  
  def monitoramento
    @clinicas = busca_clinicas.insert(0, '') #Clinica.all.collect{|obj| [ obj.nome, obj.id.to_s]}.insert(0, '')
    if params[:datepicker]
      @audits = Audit.all(:conditions=>['user_id = ? and created_at between ? and ?', params[:user_monitor_id], params[:datepicker].to_date, params[:datepicker2].to_date])
    else
      @audits = Array.new
    end
    if params[:clinica_monitor_id]
      @users = Clinica.find(params[:clinica_monitor_id]).users.collect{|obj| [obj.nome, obj.id.to_s]}
    else
      @users = Array.new
    end
  end
  
  def reiniciar_senha
    @user = User.find(params[:id])
    @user.update_attribute(:password, '1234')
  end

end
