class AcompanhamentoChequesController < ApplicationController
  
  layout "adm"
  before_filter :require_user

  def new
    @acompanhamento_cheque = AcompanhamentoCheque.new()
    @cheque                = Cheque.find(params[:cheque_id])
    @acompanhamento_cheque.cheque = @cheque
  end

  def create
    @acompanhamento_cheque = AcompanhamentoCheque.new(params[:acompanhamento_cheque])
    @acompanhamento_cheque.user = current_user
    if @acompanhamento_cheque.save
      flash[:notice] = 'Observação salva com sucesso.'
      redirect_to( session[:origem] ? session[:origem] : :back) 
    else
      render :action => new
    end
  end

end
