class UsersController < ApplicationController
  
  layout "adm"
  #before_filter :require_no_user#, :only => [:new, :create]
  before_filter :require_user#, :only => [:show, :edit, :update]

  def index
    redirect_to logout_path unless current_user.pode_incluir_user
    @users = User.ativos.por_nome
  end

  def new
    redirect_to users_path unless current_user.pode_incluir_user
    @clinicas      = Clinica.all
    @user          = User.new
    @tipos_usuario = TipoUsuario.all(:order=>:nome).collect{|obj| [obj.nome,obj.id]}
    if !current_user.master?
       master = TipoUsuario.master.collect{|obj| [obj.nome,obj.id]}
       @tipos_usuario = @tipos_usuario - master
    end
  end

  def create
    @user = User.new(params[:user])
    (1..10).each do |id|
      if params[("clinica_" + id.to_s).to_sym]
        @user.clinicas << Clinica.find(id)
      end
    end
    if @user.save
      flash[:notice] = "Usuário registrado!"
      redirect_back_or_default @user
    else  @tipos_usuario = TipoUsuario.all(:order=>:nome).collect{|obj| [obj.nome,obj.id]}
      if !current_user.master
         master = TipoUsuario.master.collect{|obj| [obj.nome,obj.id]}
         @tipos_usuario = @tipos_usuario - master
      end
      render :action => :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user     = User.find(params[:id])
    @clinicas = Clinica.all
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
       @tipos_usuario = TipoUsuario.all(:order=>:nome).collect{|obj| [obj.nome,obj.id]}
          if !current_user.master
             master = TipoUsuario.master
             @tipos_usuario = @tipos_usuario - master
          end
      render :action => :edit
    end
  end
  
  def troca_senha
    @user = current_user
  end
  
  def monitoramento
    @clinicas = Clinica.all.collect{|obj| [ obj.nome, obj.id.to_s]}.insert(0, '')
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
  
  def users_de_uma_clinica
    
  end

end
