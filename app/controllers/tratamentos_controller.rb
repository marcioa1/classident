class TratamentosController < ApplicationController
  layout "adm"
  before_filter :require_user
  def new
    @paciente               = Paciente.find(params[:paciente_id])
    @tratamento             = Tratamento.new
    @tratamento.paciente_id = @paciente.id
    @items                  = @paciente.tabela.item_tabelas.
        collect{|obj| [obj.codigo + " - " + obj.descricao,obj.id]}.insert(0,"")
    @dentistas              = @clinica_atual.dentistas.collect{|obj| [obj.nome,obj.id]}.sort
  end
  
  def create
    dentes = params[:dentes].split(',')
    Tratamento.transaction do
      respond_to do |format|
        erro = false
        dentes.each do |dente|
          @tratamento            = Tratamento.new(params[:tratamento])
          @tratamento.dente      = dente
          @tratamento.clinica_id = session[:clinica_id]
          @tratamento.excluido   = false
          erro                   = false
          if !erro && @tratamento.save 
            if !@tratamento.data.nil?
              @tratamento.finalizar_procedimento(current_user)
            end
          else
            erro = true
          end
        end
        if !erro
          format.html { redirect_to(abre_pacientes_path(:id=>@tratamento.paciente_id)) }
          format.xml  { render :xml => @tratamento, :status => :created, :location => @dentista }
        else 
          format.html { render :action => "new" }
          format.xml  { render :xml => @tratamento.errors, :status => :unprocessable_entity }
        end
      end  # respond_to
    end
  end
  
  def edit  
    @tratamento = Tratamento.find(params[:id])
    @items = @tratamento.paciente.tabela.item_tabelas.
        collect{|obj| [obj.codigo + " - " + obj.descricao,obj.id]}
    @dentistas = @clinica_atual.dentistas.collect{|obj| [obj.nome,obj.id]}
  end
  
  def update
    @tratamento = Tratamento.find(params[:id])
    @tratamento.data = params[:datepicker].to_date if params[:datepicker]
    respond_to do |format|
      if @tratamento.update_attributes(params[:tratamento])
        if !@tratamento.data.nil?
          @tratamento.paciente.verifica_alta_automatica
          @debito = Debito.find_by_tratamento_id(@tratamento.id)
          if @debito.nil?
            @debito = Debito.new
            @debito.paciente_id = @tratamento.paciente_id
            @debito.tratamento_id = @tratamento.id
          end
          @debito.descricao = @tratamento.item_tabela.descricao
          @debito.valor = @tratamento.valor
          @debito.data = @tratamento.data
          @debito.save
        end
        format.html { redirect_to(abre_pacientes_path(:id=>@tratamento.paciente_id)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tratamento.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def finalizar_procedimento
    begin
      @tratamento = Tratamento.find(params[:id])
      @tratamento.data = Date.today
      @tratamento.finalizar_procedimento(current_user)
      @tratamento.save
      @tratamento.paciente.verifica_alta_automatica(current_user, session[:clinica_id])
      head :ok
    rescue
      head :bad_request
    end
  end
end
