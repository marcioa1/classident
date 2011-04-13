class TabelaProteticosController < ApplicationController
  layout "adm"
  before_filter :require_user
  before_filter :find_current, :only => [:show, :edit, :update, :destroy, :busca_valor]

  def index
    @tabela_proteticos = TabelaProtetico.tabela_base.por_descricao
  end

  def show
  end

  def new
    @tabela_protetico = TabelaProtetico.new
    if params[:protetico_id]
      @protetico = Protetico.find(params[:protetico_id])
      @tabela_protetico.protetico = @protetico
    end
  end

  def edit
  end

  def create
    @tabela_protetico = TabelaProtetico.new(params[:tabela_protetico])

    if @tabela_protetico.save
      flash[:notice] = 'TabelaProtetico criada com sucesso.'
        if @clinica_atual.administracao?
          redirect_to(tabela_proteticos_path) 
        else
          redirect_to abre_protetico_path(@tabela_protetico.protetico)
        end
    else
      render :action => "new" 
    end
  end

  def update
    if @item.update_attributes(params[:tabela_protetico])
      if administracao
        redirect_to(tabela_proteticos_url) 
      else
        redirect_to abre_protetico_path(@item.protetico) 
      end
    else
      render :action => "edit" 
    end
  end

  def destroy
    if @clinica_atual.administracao?
      @item.destroy
      redirect_to(tabela_proteticos_url)
    else
      protetico = @item.protetico
      redirect_to(abre_protetico_path(protetico)) 
    end
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
    render :json=> @item.valor.real.to_s.to_json
  end

  def find_current
    @item = TabelaProtetico.find(params[:id])
  end
  
end
