class TratamentosController < ApplicationController
 layout "adm"
  def new
    @paciente = Paciente.find(params[:paciente_id])
    @tratamento = Tratamento.new
    @tratamento.paciente_id = @paciente.id
    @items = @paciente.tabela.item_tabelas.
        collect{|obj| [obj.codigo + " - " + obj.descricao,obj.id]}.insert(0,"")
    @dentistas = @clinica.dentistas.collect{|obj| [obj.nome,obj.id]}
  end
  
  def create
    @tratamento = Tratamento.new(params[:tratamento])
    debugger
    Tratamento.transaction do
      respond_to do |format|
        if @tratamento.save
          if !@tratamento.data.nil?
            debito = Debito.new
            debito.paciente_id = @tratamento.paciente_id
            debito.tratamento_id = @tratamento.id
            debito.descricao = @tratamento.descricao
            debito.valor = @tratamento.valor
            debito.data = @tratamento.data
            debito.save
          end
          format.html { redirect_to(abre_paciente_path(:id=>@tratamento.paciente_id)) }
          format.xml  { render :xml => @tratamento, :status => :created, :location => @dentista }
        else 
          format.html { render :action => "new" }
          format.xml  { render :xml => @tratamento.errors, :status => :unprocessable_entity }
        end
      end
    end
  end
  
  def edit  
    @tratamento = Tratamento.find(params[:id])
    @items = @tratamento.paciente.tabela.item_tabelas.
        collect{|obj| [obj.codigo + " - " + obj.descricao,obj.id]}
    @dentistas = @clinica.dentistas.collect{|obj| [obj.nome,obj.id]}
  end
  
  def update
     @tratamento = Tratamento.find(params[:id])
     
      respond_to do |format|
        if @tratamento.update_attributes(params[:tratamento])
          if !@tratamento.data.nil?
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
          format.html { redirect_to(abre_paciente_path(:id=>@tratamento.paciente_id)) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @tratamento.errors, :status => :unprocessable_entity }
        end
      end
  end
  
end
