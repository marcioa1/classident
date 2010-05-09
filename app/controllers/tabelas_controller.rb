class TabelasController < ApplicationController
  layout "adm"
  before_filter :require_user

  def index
    @tabelas = Tabela.da_clinica(session[:clinica_id]).por_nome
  end

  def show
    @tabela = Tabela.find(params[:id])
  end

  def new
    if !current_user.pode_incluir_tabela
      redirect_to tabelas_path
    else
    @tabela = Tabela.new

  end

  end

  def edit
    if !current_user.pode_incluir_tabela
      redirect_to tabelas_path
    else
      @tabela = Tabela.find(params[:id])
    end
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
    @tabela = Tabela.find(params[:id])

    if @tabela.update_attributes(params[:tabela])
      flash[:notice] = 'Tabela alterado com sucesso.'
      redirect_to(@tabela) 
    else
      render :action => "edit" 
    end
  end

  def destroy
    @tabela = Tabela.find(params[:id])
    @tabela.ativa = false
    @tabela.save

    redirect_to(tabelas_url) 
  end
  
  def print
     @tabela = Tabela.find(params[:id])
#     rghost_render :pdf, :report => {:action => 'relatorio'}, :filename => 'tabela.pdf'
  end
  #TODO terminar esta impressão
end
