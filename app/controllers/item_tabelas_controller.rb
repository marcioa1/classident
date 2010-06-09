class ItemTabelasController < ApplicationController
  layout "adm"
  before_filter :require_user

  def index
    @tabela       = Tabela.find(params[:tabela_id])
    @item_tabelas = @tabela.item_tabelas #ItemTabela.all(:conditions=>["tabela_id=?",@tabela.id], :order=>'codigo')
  end

  def show
    @item_tabela = ItemTabela.find(params[:id])
    @clinicas = Clinica.all(:order=>:nome)
    @preco = Array.new
    @clinicas.each do |clinica|
      preco = Preco.find_by_item_tabela_id_and_clinica_id(@item_tabela.id,
                  clinica.id)
      if preco.nil?
        @preco[clinica.id] = 0
      else
        @preco[clinica.id] = preco.preco
      end
    end
  end

  def new
    if !current_user.pode_incluir_tabela
      redirect_to item_tabelas_path(:tabela_id=>params[:tabela_id])
    else
      @tabela = Tabela.find(params[:tabela_id])
      @item_tabela = ItemTabela.new
      @item_tabela.tabela_id = @tabela.id
      @descricao_condutas = DescricaoConduta.all.collect{|obj| [obj.descricao, obj.id]}
    end
  end

  def edit
    if !current_user.pode_incluir_tabela
      redirect_to item_tabelas_path(:tabela_id=>params[:tabela_id])
    else
      @item_tabela = ItemTabela.find(params[:id])
      @tabela = @item_tabela.tabela
      @descricao_condutas = DescricaoConduta.all.collect{|obj| [obj.descricao, obj.id]}
    end  
  end

  def create
    @item_tabela = ItemTabela.new(params[:item_tabela])

    if @item_tabela.save
      flash[:notice] = 'ItemTabela was successfully created.'
      redirect_to(item_tabelas_path(:tabela_id=>@item_tabela.tabela_id)) 
    else
      @tabela = Tabela.find(params[:tabela_id])
      @item_tabela = ItemTabela.new
      @item_tabela.tabela_id = @tabela.id
      @descricao_condutas = DescricaoConduta.all.collect{|obj| [obj.descricao, obj.id]}
      
      render :action => "new" 
    end
  end

  def update
    @item_tabela = ItemTabela.find(params[:id])

    if @item_tabela.update_attributes(params[:item_tabela])
      flash[:notice] = 'ItemTabela alterado com sucesso.'
      redirect_to(item_tabelas_path(:tabela_id=>@item_tabela.tabela_id)) 
    else
      render :action => "edit" 
    end
  end

  def destroy
    @item_tabela       = ItemTabela.find(params[:id])
    @item_tabela.ativo = false

    @item_tabela.save
    redirect_to(item_tabelas_url) 
  end
  
  def grava_precos
    @item_tabela = ItemTabela.find(params[:item_tabela_id])
    @clinicas = Clinica.all()
    @clinicas.each do |clinica|
      valor_convertido = params["preco_" + clinica.id.to_s].gsub(",",".")
      preco = Preco.find_by_item_tabela_id_and_clinica_id(
           @item_tabela.id,clinica.id) 
      if preco.nil?
        Preco.create(:item_tabela_id=>@item_tabela.id, :clinica_id=>clinica.id,
           :preco=>valor_convertido)
      else
        preco.preco = valor_convertido
        preco.save
      end
    end
    redirect_to item_tabelas_path(:tabela_id=>@item_tabela.tabela.id)
  end
  
  def busca_descricao
    item_tabela  = ItemTabela.find(params[:id])
    result = item_tabela.descricao + ";" + item_tabela.preco_na_clinica().real.to_s
    render :json => result.to_json
  end
end
