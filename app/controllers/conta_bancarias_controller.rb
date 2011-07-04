class ContaBancariasController < ApplicationController
 
  layout "adm"
  
  before_filter :require_user

  def index
    @conta_bancarias = ContaBancaria.all
  end

  def show
    @conta_bancaria = ContaBancaria.find(params[:id])
  end

  def new
    @conta_bancaria = ContaBancaria.new
    @clinicas = Clinica.por_nome.collect{|cl| [cl.nome, cl.id]}
  end

  def edit
    @conta_bancaria = ContaBancaria.find(params[:id])
    @clinicas       = Clinica.por_nome.collect{|cl| [cl.nome, cl.id]}
  end

  def create
    @conta_bancaria = ContaBancaria.new(params[:conta_bancaria])

    if @conta_bancaria.save
      flash[:notice] = 'ContaBancaria criado com sucesso.'
      redirect_to(conta_bancarias_path) 
    else
      @clinicas = Clinica.por_nome.collect{|cl| [cl.nome, cl.id]}
      render :action => "new" 
    end
  end

  def update
    @conta_bancaria = ContaBancaria.find(params[:id])

    if @conta_bancaria.update_attributes(params[:conta_bancaria])
      flash[:notice] = 'ContaBancaria alterado com sucesso.'
      redirect_to(@conta_bancaria) 
    else
      render :action => "edit" 
    end
  end

  def destroy
    @conta_bancaria = ContaBancaria.find(params[:id])
    @conta_bancaria.destroy

    redirect_to(conta_bancarias_url) 
  end
end
