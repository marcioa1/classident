class IndicacaosController < ApplicationController

  layout "adm"
  before_filter :require_user

  def index
    @indicacaos = Indicacao.por_descricao
  end

  def show
    @indicacao = Indicacao.find(params[:id])
  end

  def new
    @indicacao = Indicacao.new
  end

  def edit
    @indicacao = Indicacao.find(params[:id])
  end

  def create
    @indicacao = Indicacao.new(params[:indicacao])
    if @indicacao.save
      redirect_to(indicacaos_path) 
    else
      render :action => "new" 
    end
  end

  def update
    @indicacao = Indicacao.find(params[:id])

    if @indicacao.update_attributes(params[:indicacao])
      redirect_to(indicacaos_path) 
    else
      render :action => "edit" 
    end
  end
 
end
