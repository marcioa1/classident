class TabelasController < ApplicationController
  layout "adm"
  before_filter :require_user
  # GET /tabelas
  # GET /tabelas.xml
  def index
    @tabelas = Tabela.da_clinica(session[:clinica_id]).por_nome

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tabelas }
    end
  end

  # GET /tabelas/1
  # GET /tabelas/1.xml
  def show
    @tabela = Tabela.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tabela }
    end
  end

  # GET /tabelas/new
  # GET /tabelas/new.xml
  def new
    if !current_user.pode_incluir_tabela
      redirect_to tabelas_path
    else
    @tabela = Tabela.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tabela }
    end
  end

  end

  # GET /tabelas/1/edit
  def edit
    if !current_user.pode_incluir_tabela
      redirect_to tabelas_path
    else
      @tabela = Tabela.find(params[:id])
    end
  end

  # POST /tabelas
  # POST /tabelas.xml
  def create
    @tabela            = Tabela.new(params[:tabela])
    @tabela.clinica_id = session[:clinica_id]
    respond_to do |format|
      if @tabela.save
        flash[:notice] = 'Tabela criada com sucesso.'
        format.html { redirect_to(tabelas_path) }
        format.xml  { render :xml => @tabela, :status => :created, :location => @tabela }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tabela.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tabelas/1
  # PUT /tabelas/1.xml
  def update
    @tabela = Tabela.find(params[:id])

    respond_to do |format|
      if @tabela.update_attributes(params[:tabela])
        flash[:notice] = 'Tabela alterado com sucesso.'
        format.html { redirect_to(@tabela) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tabela.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tabelas/1
  # DELETE /tabelas/1.xml
  def destroy
    @tabela = Tabela.find(params[:id])
    @tabela.ativa = false
    @tabela.save

    respond_to do |format|
      format.html { redirect_to(tabelas_url) }
      format.xml  { head :ok }
    end
  end
  
  def print
     @tabela = Tabela.find(params[:id])
#     rghost_render :pdf, :report => {:action => 'relatorio'}, :filename => 'tabela.pdf'
  end
  #TODO terminar esta impressão
end
