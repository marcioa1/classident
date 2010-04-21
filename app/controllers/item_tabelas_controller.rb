class ItemTabelasController < ApplicationController
  layout "adm"
  # GET /item_tabelas
  # GET /item_tabelas.xml
  def index
    @tabela       = Tabela.find(params[:tabela_id])
    @item_tabelas = @tabela.item_tabelas #ItemTabela.all(:conditions=>["tabela_id=?",@tabela.id], :order=>'codigo')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @item_tabelas }
    end
  end

  # GET /item_tabelas/1
  # GET /item_tabelas/1.xml
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
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item_tabela }
    end
  end

  # GET /item_tabelas/new
  # GET /item_tabelas/new.xml
  def new
    if !current_user.pode_incluir_tabela
      redirect_to item_tabelas_path(:tabela_id=>params[:tabela_id])
    else
      @tabela = Tabela.find(params[:tabela_id])
      @item_tabela = ItemTabela.new
      @item_tabela.tabela_id = @tabela.id
      @descricao_condutas = DescricaoConduta.all.collect{|obj| [obj.descricao, obj.id]}
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @item_tabela }
      end
    end
  end

  # GET /item_tabelas/1/edit
  def edit
    if !current_user.pode_incluir_tabela
      redirect_to item_tabelas_path(:tabela_id=>params[:tabela_id])
    else
      @item_tabela = ItemTabela.find(params[:id])
      @tabela = @item_tabela.tabela
      @descricao_condutas = DescricaoConduta.all.collect{|obj| [obj.descricao, obj.id]}
    end  
  end

  # POST /item_tabelas
  # POST /item_tabelas.xml
  def create
    @item_tabela = ItemTabela.new(params[:item_tabela])

    respond_to do |format|
      if @item_tabela.save
        flash[:notice] = 'ItemTabela was successfully created.'
        format.html { redirect_to(item_tabelas_path(:tabela_id=>@item_tabela.tabela_id)) }
        format.xml  { render :xml => @item_tabela, :status => :created, :location => @item_tabela }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @item_tabela.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /item_tabelas/1
  # PUT /item_tabelas/1.xml
  def update
    @item_tabela = ItemTabela.find(params[:id])

    respond_to do |format|
      if @item_tabela.update_attributes(params[:item_tabela])
        flash[:notice] = 'ItemTabela was successfully updated.'
        format.html { redirect_to(item_tabelas_path(:tabela_id=>@item_tabela.tabela_id)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item_tabela.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /item_tabelas/1
  # DELETE /item_tabelas/1.xml
  def destroy
    @item_tabela = ItemTabela.find(params[:id])
    @item_tabela.ativo = false

    @item_tabela.save
    respond_to do |format|
      format.html { redirect_to(item_tabelas_url) }
      format.xml  { head :ok }
    end
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
    result = item_tabela.descricao + ";" + item_tabela.preco.real.to_s
    render :json => result.to_json
  end
end
