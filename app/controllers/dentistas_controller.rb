class DentistasController < ApplicationController
  layout "adm"
  before_filter :require_user
  before_filter :quinze_dias, :on=>:producao_geral
  # GET /dentistas
  # GET /dentistas.xml
  def index
    params[:ativo] = "true" if params[:ativo].nil?
    if administracao? 
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
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dentistas }
    end
  end

  # GET /dentistas/1
  # GET /dentistas/1.xml
  def show
    @dentista = Dentista.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dentista }
    end
  end

  # GET /dentistas/new
  # GET /dentistas/new.xml
  def new
    @dentista = Dentista.new
    @clinicas = Clinica.todas.por_nome
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dentista }
    end
  end

  # GET /dentistas/1/edit
  def edit
    @dentista = Dentista.find(params[:id])
    @clinicas = Clinica.all(:order=>:nome)
  end

  # POST /dentistas
  # POST /dentistas.xml
  def create
    @dentista = Dentista.new(params[:dentista])
    @dentista.clinicas = []
    clinicas = Clinica.all
    clinicas.each() do |clinica|
      if params["clinica_#{clinica.id.to_s}"]
        @dentista.clinicas << clinica
      end      
    end
    respond_to do |format|
      if @dentista.save
        format.html { redirect_to(@dentista) }
        format.xml  { render :xml => @dentista, :status => :created, :location => @dentista }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dentista.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /dentistas/1
  # PUT /dentistas/1.xml
  def update
    @dentista = Dentista.find(params[:id])
    @dentista.clinicas = []
    clinicas = Clinica.all
    clinicas.each() do |clinica|
      if params["clinica_#{clinica.id.to_s}"]
        @dentista.clinicas << clinica
      end      
    end
    respond_to do |format|
      if @dentista.update_attributes(params[:dentista])
        format.html { redirect_to(dentistas_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dentista.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dentistas/1
  # DELETE /dentistas/1.xml
  def destroy
    @dentista = Dentista.find(params[:id])
    @dentista.ativo = false
    @dentista.save

    respond_to do |format|
      format.html { redirect_to(dentistas_url) }
      format.xml  { head :ok }
    end
  end

  def abre
    @dentista = Dentista.find(params[:id])  
    @clinicas = Clinica.all(:order=>:nome)
    @clinica_atual = Clinica.find(session[:clinica_id])
    @inicio = Date.today - 15.days
    @fim = Date.today
    @orcamentos = Orcamento.do_dentista(@dentista.id)
  end
  
  def producao
    dentista = Dentista.find(params[:id])
    inicio = params[:datepicker].to_date
    fim = params[:datepicker2].to_date
    if params[:clinicas]
      clinicas = params[:clinicas].split(",").to_a
    else
      clinicas = session[:clinica_id].to_a
    end
    @producao = dentista.busca_producao(inicio,fim,clinicas) 
    saida = "<div id='lista'><table><tr><th width='105px'>Data</th>
         <th width='220px'><br/>Paciente</th>
        <th width='220px'><br/>Procedimento</th>
        <th width='90px'><br/>Valor</th>
        <th width='90px'><br/>Custo</th>
        <th width='90px'><br/>Dentista</th>
        <th width='90px'><br/>Clínica</th>
        <th>Selecionar<br/>p/ pagto</th>
        </tr>"
    total = 0.0  
    total_dentista = 0.0
    total_custo = 0.0
    total_clinica = 0.0
    @producao.each() do |tratamento|
      saida += "<tr><td align='center'>"+ tratamento.data.to_s_br + "</td>"
      saida += "<td>" + tratamento.paciente.nome + "</td>"
      if tratamento.item_tabela.nil?
        saida += "<td>&nbsp;</td>"
      else
        saida += "<td>" + tratamento.item_tabela.descricao + "</td>"
      end  
      saida += "<td align='right'>" + tratamento.valor.real.to_s + "</td>"
      saida += "<td align='right'>" + tratamento.custo.real.to_s + "</td>"
      saida += "<td align='right'>" + tratamento.valor_dentista.real.to_s + "</td>"
      saida += "<td align='right'>" + tratamento.valor_clinica.real.to_s + "</td>"
      saida += "<td align='center'>" + "<input type='checkbox' id='pagar_dentista_" + tratamento.id.to_s + 
          "' onclick='pagar_dentista(" + tratamento.valor_dentista.to_s + ',' + tratamento.id.to_s + 
            ',' + tratamento.dentista.id.to_s +  ")'/></tr>"
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
  end
  
  def pagamento
    saida = "<div id='lista'><table><tr><th width='105px'>Data</th>
        <th width='90px'>Valor</th>
        <th width='200px'>Observação</th>
        </tr>"
        
    inicio = params[:inicio].to_date
    fim = params[:fim].to_date
    @dentista = Dentista.find(params[:dentista_id])
    @pagamentos = @dentista.pagamentos.entre_datas(inicio,fim).nao_excluidos
    total = 0.0
    @pagamentos.each do |pag|
      saida += "<tr><td>" + pag.data_de_pagamento.to_s_br + "</td>" + 
          "<td align='right'>" + pag.valor_pago.real.to_s + "</td>" + 
          "<td>" + pag.observacao + "</td>" +
         "</tr>"
         debugger
      total += pag.valor_pago
    end
    saida += "<tr><td align='center'>Total</td><td align='right'>" + total.real.to_s + "</td><td>&nbsp;</td></tr>"
    saida += "</table></div>"
    render :json => saida.to_json
  end
  
  def pesquisar
    debugger
    params[:ativo] = "true" if params[:ativo].nil?
     if administracao? 
       @dentistas = Dentista.por_nome
    else
       if params[:ativo]=="true"
        @dentistas = Clinica.find(session[:clinica_id]).dentistas.por_nome.ativos
      else
        @dentistas = Clinica.find(session[:clinica_id]).dentistas.por_nome.inativos
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dentistas }
    end
  end
  
  def orcamentos
    dentista = Dentista.find(params[:id])
    inicio = params[:inicio].to_date
    fim = params[:fim].to_date
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
    
    @todos = Dentista.ativos.por_nome
  end
  
 
  
end
