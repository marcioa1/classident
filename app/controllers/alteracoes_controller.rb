class AlteracoesController < ApplicationController
  
  layout "adm"
  
  def new
    @alteraco = Alteracoe.new(:tabela      => params[:tabela], 
                              :id_liberado => params[:id_registro])
  end

  def create
    debugger
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

end
