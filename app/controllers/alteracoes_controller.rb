class AlteracoesController < ApplicationController
  
  layout "adm"
  
  def new
    @alteraco = Alteracoe.new(:tabela      => params[:tabela], 
                              :id_liberado => params[:id_registro])
  end

  def create
    @alteraco = Alteracoe.new(params[:alteracoe])
    if @alteraco.save
      flash[:notice] = 'alteração liberada  com sucesso.'
      redirect_to :back
    else
      render :action => "new" 
    end
  end

  def index
  end

  def close
    @alteracao = Alteracoe.find_by_tabela_and_id_liberado(params[:tabela], params[:id_registro])
    @alteracao.destroy
    redirect_to :back
  end

end
