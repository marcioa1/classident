class FormasRecebimentosController < ApplicationController
  layout "adm"
  before_filter :require_user

  def index
    @formas_recebimentos = FormasRecebimento.all(:order=>:nome)
  end

  def show
    @formas_recebimento = FormasRecebimento.find(params[:id])
  end

  def new
    @formas_recebimento = FormasRecebimento.new
  end

  def edit
    @formas_recebimento = FormasRecebimento.find(params[:id])
  end

  def create
    @formas_recebimento = FormasRecebimento.new(params[:formas_recebimento])

    if @formas_recebimento.save
      redirect_to(formas_recebimentos_path) 
    else
      render :action => "new" 
    end
  end

  def update
    @formas_recebimento = FormasRecebimento.find(params[:id])

    if @formas_recebimento.update_attributes(params[:formas_recebimento])
      flash[:notice] = 'FormasRecebimento alterado com sucesso.'
      redirect_to(formas_recebimentos_path) 
    else
      render :action => "edit"
    end
  end

  def destroy
    @formas_recebimento = FormasRecebimento.find(params[:id])
    @formas_recebimento.destroy

    redirect_to(formas_recebimentos_url) 
  end
end
