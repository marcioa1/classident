class AltasController < ApplicationController

  layout "adm"

  def index
    @altas = Alta.all
  end

  def show
    @alta = Alta.find(params[:id])
  end

  def new
    @alta = Alta.new(:paciente_id => params[:paciente_id])
  end

  def edit
    @alta = Alta.find(params[:id])
  end

  def create
    @alta             = Alta.new(params[:alta])
    @alta.data_inicio = params[:datepicker].to_date
    @alta.user_id     = current_user.id
    if @alta.save
      flash[:notice] = 'Alta criada com sucesso.'
      redirect_to(abre_paciente_path(:id=>@alta.paciente_id)) 
    else
      render :action => "new" 
    end
  end

  def update
    @alta = Alta.find(params[:id])

    if @alta.update_attributes(params[:alta])
      flash[:notice] = 'Alta alterado com sucesso.'
      redirect_to(@alta) 
    else
      render :action => "edit" 
    end
  end

  def destroy
    @alta = Alta.find(params[:id])
    @alta.destroy

    redirect_to(altas_url) 
  end

end
