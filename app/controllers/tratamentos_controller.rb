class TratamentosController < ApplicationController
 layout "adm"
  def new
    @paciente = Paciente.find(params[:paciente_id])
    @tratamento = Tratamento.new
    @items = ItemTabela.all(:conditions=>["tabela_id = ? ", @paciente.id]).
        collect{|obj| [obj.codigo + " - " + obj.descricao,obj.id]}
  end
  
end
