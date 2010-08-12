class TratamentosController < ApplicationController
  layout "adm"
  before_filter :require_user
  before_filter :busca_registro, :only => [:finalizar_procedimento, :update, :edit]
  before_filter :converte_valor_lido, :only => [:create, :update]
  
  def new
    @paciente               = Paciente.find(params[:paciente_id])
    @tratamento             = Tratamento.new
    @tratamento.paciente_id = @paciente.id
    @items                  = @paciente.tabela.item_tabelas.
        collect{|obj| [obj.codigo + " - " + obj.descricao,obj.id]}.insert(0,"")
    @dentistas              = @clinica_atual.dentistas.ativos.collect{|obj| [obj.nome,obj.id]}.sort
  end
  
  def create
    erro = false
    debugger
    if Date.valid?(params[:tratamento][:data_termino_br])
      data = params[:tratamento][:data_termino_br].to_date
      if data > Date.today
        @tratamento = Tratamento.new
        @tratamento.errors.add(:data_termino_br, "Não pode ser data futura.")
        erro = true
      end
    end
    if !erro    
      dentes = params[:dentes].split(',')
      dentes.each do |dente|
        @tratamento             = Tratamento.new(params[:tratamento])
        @tratamento.paciente_id = session[:paciente_id]
        @tratamento.dente       = dente
        @tratamento.clinica_id  = session[:clinica_id]
        @tratamento.excluido    = false
        @tratamento.data        = params[:tratamento][:data_termino_br].to_date 
        if @tratamento.save 
          if !@tratamento.data.nil?
            @tratamento.finalizar_procedimento(current_user)
          end
          erro = false
        else
          erro = true
        end
      end
    end
    if erro
      @paciente = Paciente.find(session[:paciente_id])
      # @tratamento             = Tratamento.new
      # @tratamento.paciente_id = @paciente.id
      @items                  = @paciente.tabela.item_tabelas.
          collect{|obj| [obj.codigo + " - " + obj.descricao,obj.id]}.insert(0,"")
      @dentistas              = @clinica_atual.dentistas.ativos.collect{|obj| [obj.nome,obj.id]}.sort
      
      render :action => "new" 
    else
      redirect_to(abre_paciente_path(:id=>session[:paciente_id])) 
    end
  end
  
  def edit  
    @items = @tratamento.paciente.tabela.item_tabelas.
        collect{|obj| [obj.codigo + " - " + obj.descricao,obj.id]}
    @dentistas = @clinica_atual.dentistas.ativos.collect{|obj| [obj.nome,obj.id]}
  end
  
  def update
    @tratamento.data   = params[:data_de_termino].to_date if Date.valid?(params[:data_de_termino])
    if @tratamento.update_attributes(params[:tratamento])
      if !@tratamento.data.nil?
        @tratamento.paciente.verifica_alta_automatica
        @debito = Debito.find_by_tratamento_id(@tratamento.id)
        if @debito.nil? && @tratamento.orcamento.nil?
          @debito = Debito.new
          @debito.paciente_id = @tratamento.paciente_id
          @debito.tratamento_id = @tratamento.id
        end
        @debito.descricao = @tratamento.item_tabela.descricao
        @debito.valor = @tratamento.valor
        @debito.data = @tratamento.data
        @debito.save
      end
      redirect_to(abre_paciente_path(:id=>@tratamento.paciente_id)) 
    else
      render :action => "edit" 
    end
  end
  
  def finalizar_procedimento
    begin
      @tratamento.data = Date.today
      @tratamento.finalizar_procedimento(current_user)
      @tratamento.save
      @tratamento.paciente.verifica_alta_automatica(current_user, session[:clinica_id])
      head :ok
    rescue
      head :bad_request
    end
  end

  def busca_registro
    @tratamento = Tratamento.find(params[:id])
  end
  
  def converte_valor_lido
    params[:tratamento][:valor] = params[:tratamento][:valor].gsub(',', '.')
    params[:tratamento][:custo] = params[:tratamento][:custo].gsub(',', '.')
  end
  
end

