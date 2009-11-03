class UsersController < ApplicationController
  
  layout "adm"
  #before_filter :require_no_user#, :only => [:new, :create]
  before_filter :require_user#, :only => [:show, :edit, :update]

  def index
    redirect_to logout_path unless current_user.pode_incluir_user
    @users = User.ativos.por_nome
  end

  def new
    # TODO não está inserindo user
    redirect_to users_path unless current_user.pode_incluir_user
    @user = User.new
    @tipos_usuario = TipoUsuario.all(:order=>:nome).collect{|obj| [obj.nome,obj.id]}
    if !current_user.master
       master = TipoUsuario.master.collect{|obj| [obj.nome,obj.id]}
       @tipos_usuario = @tipos_usuario - master
    end
  end

  def create
    @user = User.new(params[:id])
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_back_or_default show_user_path(@user.id)
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
    @user = User.find(params[:id])
    @tipos_usuario = TipoUsuario.all(:order=>:nome).collect{|obj| [obj.nome,obj.id]}
    if !current_user.master
       master = TipoUsuario.master.collect{|obj| [obj.nome,obj.id]}
       @tipos_usuario = @tipos_usuario - master
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
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
    
  end
  
end
