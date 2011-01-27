class AcompanhamentoChequesController < ApplicationController
 
  def new
    @acompanhamento = AcompanhamentoCheque.new
  end

  def create
    @acompanhamento = AcompanhamentoCheque.new(params[:acompanhamento])
    if @acompanhamento.save
      flash[:notice] = 'Observação salva com sucesso.'
      redirect_to :back
    else
      render :action => new
    end
  end

end
