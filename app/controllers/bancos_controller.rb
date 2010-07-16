class BancosController < ApplicationController
 
  layout "adm"
  
  before_filter :require_user

  def index
    @bancos = Banco.por_nome
  end

  def show
    @banco = Banco.find(params[:id])
  end

  def new
    @banco = Banco.new
  end

  def edit
    @banco = Banco.find(params[:id])
  end

  def create
    @banco = Banco.new(params[:banco])

    if @banco.save
      flash[:notice] = 'Banco criado com sucesso.'
      redirect_to(bancos_path) 
    else
      render :action => "new" 
    end
  end

  def update
    @banco = Banco.find(params[:id])

    if @banco.update_attributes(params[:banco])
      flash[:notice] = 'Banco alterado com sucesso.'
      redirect_to(bancos_path) 
    else
      render :action => "edit" 
    end
  end

  def destroy
    @banco = Banco.find(params[:id])
    @banco.destroy

    redirect_to(bancos_url) 
  end
end
