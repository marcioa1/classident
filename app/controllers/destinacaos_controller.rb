class DestinacaosController < ApplicationController

  layout "adm"
  
  def index
    @destinacaos = Destinacao.all(:conditions=>(["clinica_id =?",  session[:clinica_id]]), :order=>:nome)
  end

  def show
    @destinacao = Destinacao.find(params[:id])
  end

  def new
    @destinacao = Destinacao.new
  end

  def edit
    @destinacao = Destinacao.find(params[:id])
  end

  def create
    @destinacao = Destinacao.new(params[:destinacao])
    @destinacao.clinica_id = session[:clinica_id]

    if @destinacao.save
      flash[:notice] = 'Destinacao criado com sucesso.'
      redirect_to(destinacaos_path) 
    else
      render :action => "new" 
    end
  end

  def update
    @destinacao = Destinacao.find(params[:id])

    if @destinacao.update_attributes(params[:destinacao])
      flash[:notice] = 'Destinacao alterado com sucesso.'
      redirect_to(@destinacao) 
    else
      render :action => "edit" 
    end
  end

  def destroy
    @destinacao = Destinacao.find(params[:id])
    @destinacao.destroy

    redirect_to(destinacaos_url) 
  end
end
