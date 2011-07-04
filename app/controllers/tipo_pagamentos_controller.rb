class TipoPagamentosController < ApplicationController
  layout "adm"
  before_filter :require_user 
  before_filter :require_user

  def index
    params[:ativo] = 'true' if !params[:ativo]
    if params[:ativo] == 'true'
      @tipo_pagamentos = TipoPagamento.da_clinica(session[:clinica_id]).por_nome.ativos
    else
      @tipo_pagamentos = TipoPagamento.da_clinica(session[:clinica_id]).por_nome.inativos
    end
    if params[:iniciais].present?
         @tipo_pagamentos = @tipo_pagamentos.que_iniciam_com(params[:iniciais])
    end
  end

  def show
    @tipo_pagamento = TipoPagamento.find(params[:id])
  end

  def new
    @tipo_pagamento = TipoPagamento.new
    @tipo_pagamento.clinica_id = session[:clinica_id]
    @tipo_pagamento.ativo = true
  end

  def edit
    @tipo_pagamento = TipoPagamento.find(params[:id])
  end

  def create
    @tipo_pagamento = TipoPagamento.new(params[:tipo_pagamento])

    if @tipo_pagamento.save
      flash[:notice] = 'TipoPagamento criado com sucesso.'
      redirect_to(tipo_pagamentos_path) 
    else
      render :action => "new" 
    end
  end

  def update
    @tipo_pagamento = TipoPagamento.find(params[:id])

    if @tipo_pagamento.update_attributes(params[:tipo_pagamento])
      flash[:notice] = 'TipoPagamento alterado com sucesso.'
      redirect_to(@tipo_pagamento) 
    else
      render :action => "edit" 
    end
  end

  def destroy
    @tipo_pagamento       = TipoPagamento.find(params[:id])
    @tipo_pagamento.ativo = false
    @tipo_pagamento.save

    redirect_to(tipo_pagamentos_url) 
  end
  
  def reativar
    @tipo_pagamento       = TipoPagamento.find(params[:id])
    @tipo_pagamento.ativo = true
    @tipo_pagamento.save

    redirect_to(tipo_pagamentos_url) 
  end
end
