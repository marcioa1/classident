class OrcamentosController < ApplicationController
  layout "adm"
  # GET /orcamentos
  # GET /orcamentos.xml
  def index
    @orcamentos = Orcamento.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orcamentos }
    end
  end

  # GET /orcamentos/1
  # GET /orcamentos/1.xml
  def show
    @orcamento = Orcamento.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @orcamento }
    end
  end

  # GET /orcamentos/new
  # GET /orcamentos/new.xml
  def new
    params[:tratamento_ids] = Tratamento.ids_orcamento(params[:paciente_id]).join(",")
    @paciente = Paciente.find(params[:paciente_id])
    @orcamento = Orcamento.new
    @orcamento.paciente = @paciente
    @orcamento.numero = Orcamento.proximo_numero(params[:paciente_id])
    @orcamento.valor = Tratamento.valor_a_fazer(params[:paciente_id])
    @orcamento.desconto = 0
    @orcamento.valor_com_desconto = @orcamento.valor
    @dentistas = Clinica.find(session[:clinica_id]).dentistas.ativos.por_nome.collect{|obj| [obj.nome,obj.id]}
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @orcamento }
    end
  end

  # GET /orcamentos/1/edit
  def edit
    @orcamento = Orcamento.find(params[:id])
    @paciente = @orcamento.paciente
    @dentistas = Clinica.find(session[:clinica_id]).dentistas.ativos.por_nome.collect{|obj| [obj.nome,obj.id]}
  end

  # POST /orcamentos
  # POST /orcamentos.xml
  def create
    @orcamento = Orcamento.new(params[:orcamento])
    @orcamento.data = params[:datepicker].to_date
    @orcamento.vencimento_primeira_parcela = params[:datepicker2].to_date
    @orcamento.data_de_inicio = params[:datepicker3].to_date unless params[:datepicker3].blank?
    respond_to do |format|
      if @orcamento.save
        Tratamento.associa_ao_orcamento(params[:tratamento_ids], @orcamento.id)
         Debito.cria_debitos_do_orcamento(@orcamento.id) unless @orcamento.data_de_inicio.nil?
        format.html { redirect_to(abre_paciente_path(@orcamento.paciente_id)) }
        format.xml  { render :xml => @orcamento, :status => :created, :location => @orcamento }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @orcamento.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /orcamentos/1
  # PUT /orcamentos/1.xml
  def update
    @orcamento = Orcamento.find(params[:id])
    @orcamento.data = params[:datepicker].to_date
    @orcamento.vencimento_primeira_parcela = params[:datepicker2].to_date
    @orcamento.data_de_inicio = params[:datepicker3].to_date unless params[:datepicker3].blank?
    
    respond_to do |format|
      if @orcamento.update_attributes(params[:orcamento])
        format.html { redirect_to(abre_paciente_path(@orcamento.paciente_id)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @orcamento.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /orcamentos/1
  # DELETE /orcamentos/1.xml
  def destroy
    @orcamento = Orcamento.find(params[:id])
    @orcamento.destroy

    respond_to do |format|
      format.html { redirect_to(orcamentos_url) }
      format.xml  { head :ok }
    end
  end
  
  def relatorio
    if params[:datepicker].nil?
      params[:datepicker] = Date.today
      params[:datepicker2] = Date.today
    end
    @orcamentos = Orcamento.da_clinica(session[:clinica_id]).entre_datas(params[:datepicker].to_date, params[:datepicker2].to_date)
    
  end
end
