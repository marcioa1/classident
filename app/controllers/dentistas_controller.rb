class DentistasController < ApplicationController
  layout "adm"
  before_filter :require_user
  before_filter :quinze_dias, :on=>:producao_geral
  before_filter :busca_dentista, :only=>[:abre, :desativar, :update, :destroy, :show, :edit]

  def index
    params[:ativo] = "true" if params[:ativo].nil?
    if @administracao 
      if params[:ativo]=="true"
        @dentistas = Dentista.por_nome.ativos
      else
        @dentistas = Dentista.por_nome.inativos
      end
    else
      if params[:ativo]=="true"
        @dentistas = Clinica.find(session[:clinica_id]).dentistas.por_nome.ativos
      else
        @dentistas = Clinica.find(session[:clinica_id]).dentistas.por_nome.inativos
      end
    end
    if !params[:iniciais].nil? and !params[:iniciais].blank?
      @dentistas = @dentistas.que_iniciam_com(params[:iniciais])
    end
  end

  def show
  end

  def new
    @dentista = Dentista.new
    @clinicas = Clinica.todas.por_nome
  end

  def edit
    @clinicas = busca_clinicas #Clinica.all(:order=>:nome)
  end

  def create
    @dentista = Dentista.new(params[:dentista])
    @dentista.clinicas = []
    clinicas = busca_clinicas #Clinica.all
    clinicas.each() do |clinica|
      if params["clinica_#{clinica.id.to_s}"]
        @dentista.clinicas << clinica
      end      
    end

    if @dentista.save
      redirect_to(@dentista) 
    else
      render :action => "new" 
    end
  end

  def update
    @dentista.clinicas = []
    clinicas = busca_clinicas #Clinica.all
    clinicas.each() do |clinica|
      if params["clinica_#{clinica.id.to_s}"]
        @dentista.clinicas << clinica
      end      
    end
      if @dentista.update_attributes(params[:dentista])
        redirect_to(dentistas_path) 
      else
        render :action => "edit" 
      end
  end

  def destroy
    @dentista.ativo = false
    @dentista.save

    redirect_to(dentistas_path) 
  end
  
  def reativar
    @dentista.ativo = true
    @dentista.save
    redirect_to(dentistas_path())
  end

  def abre
    @clinicas      = busca_clinica #Clinica.all(:order=>:nome)
    @clinica_atual = Clinica.find(session[:clinica_id])
    quinzena
    @orcamentos    = Orcamento.do_dentista(@dentista.id)
#TODO fazer campo pagamenti0_id ao tratamento  

  end
  
  def producao
    debugger
    dentista = Dentista.find(params[:id])
    if !params[:datepicker]
      quinzena
      params[:datepicker]  = @data_inicial.to_s_br
      params[:datepicker2] = @data_final.to_s_br
    end
    if params[:clinicas]
      clinicas = params[:clinicas].split(",").to_a
    else
      clinicas = session[:clinica_id].to_a
    end
    if Date.valid?(params[:datepicker]) && Date.valid?(params[:datepicker2])
      inicio   = params[:datepicker].to_date if Date.valid?(params[:datepicker])
      fim      = params[:datepicker2].to_date if Date.valid?(params[:datepicker2])
      @producao = dentista.busca_producao(inicio,fim,clinicas) 
      saida = "<div id='lista'><table><tr><th width='105px'>Data</th>
           <th width='220px'><br/>Paciente</th>
          <th width='220px'><br/>Procedimento</th>
          <th width='90px'><br/>Valor</th>
          <th width='90px'><br/>Custo</th>
          <th width='90px'><br/>Dentista</th>
          <th width='90px'><br/>Clínica</th>"
      saida += "<th>Selecionar<br/>p/ pagto</th>" if @administracao
      saida += "</tr>"
      total = 0.0  
      total_dentista = 0.0
      total_custo = 0.0
      total_clinica = 0.0
      @producao.each() do |tratamento|
        saida += "<tr><td align='center'>"+ tratamento.data.to_s_br + "</td>"
        saida += "<td>" + tratamento.paciente.nome + "</td>"
        saida += "<td>" + tratamento.descricao + "</td>"
        saida += "<td align='right'>" + tratamento.valor.real.to_s + "</td>"
        saida += "<td align='right'>" + tratamento.custo.real.to_s + "</td>"
        saida += "<td align='right'>" + tratamento.valor_dentista.real.to_s + "</td>"
        saida += "<td align='right'>" + tratamento.valor_clinica.real.to_s + "</td>"
        saida += "<td align='center'>" + "<input type='checkbox' id='pagar_dentista_" + tratamento.id.to_s + 
            "' onclick='pagar_dentista(" + tratamento.valor_dentista.to_s + ',' + tratamento.id.to_s + 
              ',' + tratamento.dentista.id.to_s +  ")'/></tr>" if @administracao
        total_dentista += tratamento.valor_dentista
        total_custo += tratamento.custo unless tratamento.custo.nil?
        total_clinica += tratamento.valor_clinica
        total += tratamento.valor
      end
      saida += "<tr><td colspan='3' align='center'>Total</td><td align='right'>" + total.real.to_s + "</td>"
      saida += "<td align='right'>"+total_custo.real.to_s + "</td>"
      saida += "<td align='right'>"+ total_dentista.real.to_s + "</td><td align='right'>" + total_clinica.real.to_s + "</td></tr>"
    
      saida += "</table></div>"
      render :json => saida.to_json
    else
      @erros = ''
      @erros = "Data inicial inválida." if !Date.valid?(params[:datepicker])
      @erros += "Data final inválida." if !Date.valid?(params[:datepicker2])
    end
  
  end
  
  def pagamento
    saida = "<div id='lista'><table><tr><th width='105px'>Data</th>
        <th width='90px'>Valor</th>
        <th width='200px'>Observação</th>
        </tr>"
        
    inicio      = params[:inicio].to_date
    fim         = params[:fim].to_date
    @dentista   = Dentista.find(params[:dentista_id])
    @pagamentos = @dentista.pagamentos.entre_datas(inicio,fim).nao_excluidos
    total = 0.0
    @pagamentos.each do |pag|
      saida += "<tr><td>" + pag.data_de_pagamento.to_s_br + "</td>" + 
          "<td align='right'>" + pag.valor_pago.real.to_s + "</td>" + 
          "<td>" + pag.observacao + "</td>" +
         "</tr>"
      total += pag.valor_pago
    end
    saida += "<tr><td align='center'>Total</td><td align='right'>" + total.real.to_s + "</td><td>&nbsp;</td></tr>"
    saida += "</table></div>"
    render :json => saida.to_json
  end
  
  def pesquisar
    params[:ativo] = "true" if params[:ativo].nil?
     if @administracao 
       @dentistas = Dentista.por_nome
    else
       if params[:ativo]=="true"
        @dentistas = Clinica.find(session[:clinica_id]).dentistas.por_nome.ativos
      else
        @dentistas = Clinica.find(session[:clinica_id]).dentistas.por_nome.inativos
      end
    end

  end
  
  def orcamentos
    dentista = Dentista.find(params[:id])
    inicio   = params[:inicio].to_date
    fim      = params[:fim].to_date
    if params[:clinicas]
      clinicas = params[:clinicas].split(",").to_a
    else
      clinicas = session[:clinica_id].to_a
    end
    result = "<div id='lista_orcamento'><table><tr>
        <th><br/>Data</th>
        <th><br/>Paciente</th>
        <th width='100px'><br/>Valor</th>
        <th><br/>Desconto</th>
        <th width='100px'>Valor c/ desconto</th>
        <th>Núm. de<br/> parcelas</th>
        <th width='100px'><br/>Valor parcela</th>
        <th><br/>Estado</th>
      </tr>"
    @orcamentos = Orcamento.do_dentista(dentista.id).entre_datas(inicio,fim)
    @orcamentos.each do |orca|
      result += "<tr><td>" + orca.data.to_s_br + "</td><td>" + orca.paciente.nome + "</td><td align='right'>" 
      result += orca.valor.real.to_s + "</td>" +
      "<td align='right'>" + orca.desconto.to_s + "</td><td align='right'>" + orca.valor_com_desconto.real.to_s + 
      "<td align='right'>" + orca.numero_de_parcelas.to_s + "</td><td align='right'>" + orca.valor_da_parcela.real.to_s + "</td>"+
      "<td>" + orca.estado + "</td>" +
      "</tr>" 
      
    end
    result += "</table></div>"
    render :json => result.to_json
  end
  
  def producao_geral
    if !params[:datepicker]
      quinzena
    else
      @data_inicial = params[:datepicker].to_date if Date.valid?(params[:datepicker])
      @data_final   = params[:datepicker2].to_date if Date.valid?(params[:datepicker2])
    end
    if Date.valid?(params[:datepicker]) && Date.valid?(params[:datepicker2])
      @todos = Tratamento.dentistas_entre_datas(@data_inicial,@data_final)
    else
      @todos = []
      @erros = ''
      @erros = "Data inicial inválida." if params[:datepicker] && !Date.valid?(params[:datepicker])
      @erros += "Data final inválida." if params[:datepicker2] && !Date.valid?(params[:datepicker2])
    end
    # Dentista.ativos.por_nome
  end
  
  def busca_dentista
    @dentista = Dentista.find(params[:id])  
  end
  
end
