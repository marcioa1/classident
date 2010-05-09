class DescricaoCondutasController < ApplicationController

  layout "adm"
  
  def index
    @descricao_condutas = DescricaoConduta.all
  end

  def show
    @descricao_conduta = DescricaoConduta.find(params[:id])
  end

  def new
    @descricao_conduta = DescricaoConduta.new
  end

  def edit
    @descricao_conduta = DescricaoConduta.find(params[:id])
  end

  def create
    @descricao_conduta = DescricaoConduta.new(params[:descricao_conduta])

    if @descricao_conduta.save
      redirect_to(descricao_condutas_path) 
    else
      render :action => "new"
    end
  end

  def update
    @descricao_conduta = DescricaoConduta.find(params[:id])

    if @descricao_conduta.update_attributes(params[:descricao_conduta])
      redirect_to(descricao_condutas_path) 
    else
      render :action => "edit" 
    end
  end

  def destroy
    @descricao_conduta = DescricaoConduta.find(params[:id])
    @descricao_conduta.destroy

    redirect_to(descricao_condutas_url) 
  end
end
