class TabelaProteticosController < ApplicationController
  layout "adm"
  before_filter :require_user

  def index
    @tabela_proteticos = TabelaProtetico.tabela_base.por_descricao
  end

  def show
    @tabela_protetico = TabelaProtetico.find(params[:id])
  end

  def new
    @tabela_protetico = TabelaProtetico.new
    if params[:protetico_id]
      @protetico = Protetico.find(params[:protetico_id])
      @tabela_protetico.protetico = @protetico
    end
  end

  def edit
    @tabela_protetico = TabelaProtetico.find(params[:id])
  end

  def create
    @tabela_protetico = TabelaProtetico.new(params[:tabela_protetico])

    if @tabela_protetico.save
      flash[:notice] = 'TabelaProtetico criada com sucesso.'
        if @administracao
          redirect_to(tabela_proteticos_path) 
        else
          redirect_to abre_protetico_path(@tabela_protetico.protetico)
        end
    else
      render :action => "new" 
    end
  end

  def update
    @tabela_protetico = TabelaProtetico.find(params[:id])

    if @tabela_protetico.update_attributes(params[:tabela_protetico])
      redirect_to abre_protetico_path(@tabela_protetico.protetico) 
    else
      render :action => "edit" 
    end
  end

  def destroy
    @tabela_protetico = TabelaProtetico.find(params[:id])
    protetico         = @tabela_protetico.protetico
    @tabela_protetico.destroy

    @administracao ? redirect_to(tabela_proteticos_url) : redirect_to(abre_protetico_path(protetico)) 
  end
  
  def importa_tabela_base
    @protetico = Protetico.find(params[:protetico_id])
    @itens     = TabelaProtetico.tabela_base
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
