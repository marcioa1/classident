class TratamentosController < ApplicationController
  layout "adm"
  before_filter :require_user
  before_filter :busca_registro, :only => [:finalizar_procedimento, :update, :edit, :destroy]
  before_filter :converte_valor_lido, :only => [:create, :update]
  
  def new
    @paciente               = Paciente.find(params[:paciente_id])
    @tratamento             = Tratamento.new(:dentista_id => params[:dentista_id])
    @tratamento.paciente_id = @paciente.id
    if @paciente.tabela
      @items                = @paciente.tabela.item_tabelas.
        collect{|obj| [obj.codigo + " - " + obj.descricao,obj.id]}.insert(0,"")
    else
      @items = []
    end
    @dentistas = Dentista.busca_dentistas(session[:clinica_id])
  end
  
  def create
    @tratamento = Tratamento.new(params[:tratamento])
    dentes      = params[:tratamento][:dente].empty? ? [' '] : params[:tratamento][:dente].split(',') 
    erro        = false
    dentes.each do |dente|
      @tratamento             = Tratamento.new(params[:tratamento])
      @tratamento.paciente_id = session[:paciente_id]
      @tratamento.dente       = dente
      @tratamento.clinica_id  = session[:clinica_id]
      @tratamento.excluido    = false
      if @tratamento.save 
        @tratamento.finalizar(current_user, session[:clinica_id]) if @tratamento.data
      else
        erro = true
      end
    end
    if erro
      @paciente   = Paciente.find(session[:paciente_id])
      @items      = @paciente.tabela.item_tabelas.
          collect{|obj| [obj.codigo + " - " + obj.descricao,obj.id]}.insert(0,"")
      @dentistas  = @clinica_atual.dentistas.ativos.collect{|obj| [obj.nome,obj.id]}.sort

      render :action => "new"
    else
      if params[:commit] == 'salvar e novo'
        redirect_to new_tratamento_path(:paciente_id => @tratamento.paciente_id, :dentista_id=>@tratamento.dentista.id)
      else
        redirect_to(abre_paciente_path(:id=>session[:paciente_id])) 
      end
    end
  end
  
  def edit      
    @paciente = @tratamento.paciente
    @items    = []
    if @tratamento.paciente.tabela && @tratamento.paciente.tabela.item_tabelas
      @items = @tratamento.paciente.tabela.item_tabelas.
        collect{|obj| [obj.codigo + " - " + obj.descricao,obj.id]}
    end
    @dentistas = @clinica_atual.dentistas.ativos.collect{|obj| [obj.nome,obj.id]}
  end
  
  def update
    estava_terminado = @tratamento.data.present?
    if Date.valid?(params[:data_de_termino]) 
      @tratamento.data   = params[:data_de_termino].to_date
    end
    
    if @tratamento.update_attributes(params[:tratamento])
      if @tratamento.data.blank? && estava_terminado
        @debito = @tratamento.debito
        @debito.destroy
        @tratamento.debito = nil
      end
      if @tratamento.data.present? 
        if !estava_terminado
          @tratamento.finalizar(current_user, session[:clinica_id])
        else
          # alterar débito
          @debito = Debito.find_by_tratamento_id(@tratamento.id)
          if @debito.nil? 
            @debito = Debito.new      
            @debito.paciente_id   = @tratamento.paciente_id
            @debito.tratamento_id = @tratamento.id
            @debito.clinica_id    = session[:clinica_id]
          end
          @debito.descricao = @tratamento.descricao
          @debito.valor     = @tratamento.valor_com_desconto
          @debito.data      = @tratamento.data
          @debito.save
        end
        
        # Alta.verifica_alta_automatica(current_user, session[:clinica_id], @tratamento)
      end
      Alteracoe.retira_permissao_de_alteracao('tratamentos', @tratamento.id, current_user.id) if !@tratamento.na_quinzena?
      redirect_to(abre_paciente_path(:id=>@tratamento.paciente_id)) 
    else
      @paciente               = @tratamento.paciente

      @items = @tratamento.paciente.tabela.item_tabelas.
        collect{|obj| [obj.codigo + " - " + obj.descricao,obj.id]}
      @dentistas = @clinica_atual.dentistas.ativos.collect{|obj| [obj.nome,obj.id]}

      render :action => "edit" 
    end
  end
  
  def destroy
    paciente  = @tratamento.paciente
    if @tratamento.pode_excluir? || @tratamento.liberado_para_alteracao?
      Debito.find_by_tratamento_id(@tratamento.id).try(:destroy) if @tratamento.data
      @tratamento.destroy
      Alteracoe.retira_permissao_de_alteracao('tratamentos', @tratamento.id, current_user.id) if !@tratamento.na_quinzena?
    end
    redirect_to(abre_paciente_path(paciente) )
  end
  
  def finalizar_procedimento
    begin
      @tratamento.data = Date.today
      @tratamento.finalizar(current_user, session[:clinica_id])
      @tratamento.save!
      @paciente        = Paciente.find(@tratamento.paciente_id)
      Alta.verifica_alta_automatica(current_user, session[:clinica_id], @tratamento)
      Rails.cache.write(@paciente.id.to_s, @paciente, :expires_in => 2.minutes) 
      # redirect_to(abre_paciente_path(paciente) )
      render :partial => 'pacientes/extrato', :locals => {:paciente => @paciente}
    rescue  Exception => ex
      head :bad_request
    end
  end

  def busca_registro
    @tratamento = Tratamento.find(params[:id])
  end
  
  def converte_valor_lido
    # params[:tratamento][:valor] = params[:tratamento][:valor].gsub(',', '.')
    # params[:tratamento][:custo] = params[:tratamento][:custo].gsub(',', '.')
  end
  
end

