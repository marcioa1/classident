class TabelasController < ApplicationController
  layout "adm"
  before_filter :require_user
  before_filter :find_tabela, :only => [:show, :edit, :update, :destroy, :reativar, :desativar]

  def index
    if params[:ativa] == 'nao'
      @tabelas = Tabela.da_clinica(session[:clinica_id]).por_nome.inativas
    else
      params[:ativa] = 'sim'
      @tabelas       = Tabela.da_clinica(session[:clinica_id]).por_nome.ativas
    end
  end

  def show
  end

  def new
      @tabela = Tabela.new
  end

  def edit
  end

  def create
    @tabela            = Tabela.new(params[:tabela])
    @tabela.clinica_id = session[:clinica_id]

    if @tabela.save
      flash[:notice] = 'Tabela criada com sucesso.'
      redirect_to(tabelas_path) 
    else
      render :action => "new" 
    end
  end

  def update
    if @tabela.update_attributes(params[:tabela])
      flash[:notice] = 'Tabela alterado com sucesso.'
      redirect_to(@tabela) 
    else
      render :action => "edit" 
    end
  end

  def destroy
    @tabela.ativa = false
    @tabela.save

    redirect_to(tabelas_url) 
  end
  
  def reativar
    @tabela.ativa = true
    @tabela.save
    redirect_to(tabelas_url) 
  end
  
  def desativar
    @tabela.update_attribute('ativa',false)
    head :ok
  end
  
  def print
#     rghost_render :pdf, :report => {:action => 'relatorio'}, :filename => 'tabela.pdf'
  end
  #TODO terminar esta impressão
  
  def find_tabela
    @tabela = Tabela.find(params[:id])
  end
end
