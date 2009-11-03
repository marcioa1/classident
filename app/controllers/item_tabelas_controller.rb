class ItemTabelasController < ApplicationController
  layout "adm"
  # GET /item_tabelas
  # GET /item_tabelas.xml
  def index
    @tabela = Tabela.find(params[:tabela_id])
    @item_tabelas = ItemTabela.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @item_tabelas }
    end
  end

  # GET /item_tabelas/1
  # GET /item_tabelas/1.xml
  def show
    @item_tabela = ItemTabela.find(params[:id])

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
end
