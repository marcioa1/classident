class TabelaProteticosController < ApplicationController
  layout "adm"
  # GET /tabela_proteticos
  # GET /tabela_proteticos.xml
  def index
    @tabela_proteticos = TabelaProtetico.tabela_base.por_descricao

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tabela_proteticos }
    end
  end

  # GET /tabela_proteticos/1
  # GET /tabela_proteticos/1.xml
  def show
    @tabela_protetico = TabelaProtetico.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tabela_protetico }
    end
  end

  # GET /tabela_proteticos/new
  # GET /tabela_proteticos/new.xml
  def new
    @tabela_protetico = TabelaProtetico.new
    if params[:protetico_id]
      @protetico = Protetico.find(params[:protetico_id])
      @tabela_protetico.protetico = @protetico
    end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tabela_protetico }
    end
  end

  # GET /tabela_proteticos/1/edit
  def edit
    @tabela_protetico = TabelaProtetico.find(params[:id])
  end

  # POST /tabela_proteticos
  # POST /tabela_proteticos.xml
  def create
    @tabela_protetico = TabelaProtetico.new(params[:tabela_protetico])

    respond_to do |format|
      if @tabela_protetico.save
        flash[:notice] = 'TabelaProtetico was successfully created.'
        format.html { 
          if session[:clinica_id].to_i == 0
            redirect_to(tabela_proteticos_path) 
          else
            redirect_to abre_protetico_path(@tabela_protetico.protetico)
          end
          }
        format.xml  { render :xml => @tabela_protetico, :status => :created, :location => @tabela_protetico }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tabela_protetico.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tabela_proteticos/1
  # PUT /tabela_proteticos/1.xml
  def update
    @tabela_protetico = TabelaProtetico.find(params[:id])

    respond_to do |format|
      if @tabela_protetico.update_attributes(params[:tabela_protetico])
        format.html { redirect_to abre_protetico_path(@tabela_protetico.protetico)  }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tabela_protetico.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tabela_proteticos/1
  # DELETE /tabela_proteticos/1.xml
  def destroy
    @tabela_protetico = TabelaProtetico.find(params[:id])
    @tabela_protetico.destroy

    respond_to do |format|
      format.html { redirect_to(tabela_proteticos_url) }
      format.xml  { head :ok }
    end
  end
  
  def importa_tabela_base
    debugger
    @protetico = Protetico.find(params[:protetico_id])
    @itens = TabelaProtetico.tabela_base
    @itens.each do |item|
      item = TabelaProtetico.create(:protetico_id=> @protetico.id,
             :codigo=>item.codigo, :descricao=> item.descricao,
             :valor=>item.valor)
      @protetico.tabela_proteticos << item
    end
    @protetico.save
    redirect_to abre_protetico_path(@protetico)
  end
  
  def busca_valor
    @item = TabelaProtetico.find(params[:item_id])
    render :json=> @item.valor.to_json
  end
end
