class RecebimentosController < ApplicationController
  
  layout "adm"
  
  before_filter :require_user
  before_filter :busca_bancos_e_forma_de_recebimento, :only=>[:new, :edit]
  
  # GET /recebimentos
  # GET /recebimentos.xml
  def index
    @recebimentos = Recebimento.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @recebimentos }
    end
  end

  # GET /recebimentos/1
  # GET /recebimentos/1.xml
  def show
    @recebimento = Recebimento.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @recebimento }
    end
  end

  # GET /recebimentos/new
  # GET /recebimentos/new.xml
  def new
    @recebimento             = Recebimento.new
    @recebimento.cheque      = Cheque.new
    @paciente                = Paciente.find(params[:paciente_id])
    @recebimento.paciente    = @paciente
    @recebimento.clinica_id  = @paciente.clinica_id
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @recebimento }
    end
  end

  # GET /recebimentos/1/edit
  def edit
    @recebimento     = Recebimento.find(params[:id])
    @cheque          = @recebimento.cheque
    @paciente        = @recebimento.paciente
    if @recebimento.cheque.nil?
      @recebimento.cheque = Cheque.new
    end
  end

  # POST /recebimentos
  # POST /recebimentos.xml
  def create
    @recebimento = Recebimento.new(params[:recebimento])
    @recebimento.data = params[:datepicker].to_date
    
    if @recebimento.em_cheque?
     # @cheque.error.add_on_blank(:cheque, :valor) if params[:banco_id].to_i == 0
      @cheque = Cheque.new
      @cheque.bom_para        = params[:datepicker2].to_date
      @cheque.clinica_id      = session[:clinica_id]
      @cheque.paciente_id     = @recebimento.paciente_id
      @cheque.banco_id        = params[:banco_id]
      @cheque.agencia         = params[:agencia]
      @cheque.numero          = params[:numero]
      @cheque.conta_corrente  = params[:conta_corrente]
      @cheque.valor           = params[:valor]
      @recebimento.cheque     = @cheque
      @recebimento.errors.add(:banco, 'não pode ser branco') if !@cheque.banco.present?
      @recebimento.errors.add(:numero, 'do cheque não pode ser branco') if !@cheque.numero.present?
      @recebimento.errors.add(:valor, ' do cheque não pode ser branco') if !@cheque.valor.present?
    else
      @cheque = nil
    end
    if params[:segundo_paciente].present?
      @recebimento2                       = Recebimento.new
      @recebimento2.paciente_id           = params[:id_segundo_paciente]
      @recebimento2.valor                 = params[:valor_paciente_2]
      @recebimento2.observacao            = params[:observacao_paciente_2]
      @recebimento2.formas_recebimento_id = params[:recebimento][:formas_recebimento_id]
      @recebimento2.data                  = params[:datepicker].to_date
      @recebimento2.clinica_id            = session[:clinica_id]
      @recebimento2.cheque                = @cheque
    end
    if params[:terceiro_paciente].present?
      @recebimento3                       = Recebimento.new
      @recebimento3.paciente_id           = params[:id_terceiro_paciente]
      @recebimento3.valor                 = params[:valor_paciente_3]
      @recebimento3.observacao            = params[:observacao_paciente_3]
      @recebimento3.formas_recebimento_id = params[:recebimento][:formas_recebimento_id]
      @recebimento3.data                  = params[:datepicker].to_date
      @recebimento3.clinica_id            = session[:clinica_id]
      @recebimento3.cheque                = @cheque
    end
    Recebimento.transaction do
      respond_to do |format|
        if (@recebimento.em_cheque? && @cheque.valid?) && @recebimento.save 
          format.html { redirect_to(abre_pacientes_path(:id=>@recebimento.paciente_id)) }
          format.xml  { render :xml => @recebimento, :status => :created, :location => @recebimento }
        else
          @paciente = Paciente.find(session[:paciente_id])
          @bancos = Banco.all(:order=>:nome).collect{|obj| [obj.numero + " - " + obj.nome,obj.id]}
          @formas_recebimentos = FormasRecebimento.por_nome.collect{|obj| [obj.nome,obj.id]}
          
          format.html { render :action => "new" }
          format.xml  { render :xml => @recebimento.errors, :status => :unprocessable_entity }
        end
      end #transaction
    end
  end

  # PUT /recebimentos/1
  # PUT /recebimentos/1.xml
  def update
    @recebimento = Recebimento.find(params[:id])
    @recebimento.data = params[:datepicker].to_date
    if @recebimento.em_cheque?
      @recebimento.cheque.bom_para = params[:datepicker2].to_date
      @recebimento.cheque.clinica_id = session[:clinica_id]
      @recebimento.cheque.paciente_id = @recebimento.paciente_id
    else
      @recebimento.cheque = nil
    end

    respond_to do |format|
      if @recebimento.update_attributes(params[:recebimento])
        format.html { redirect_to(abre_pacientes_path(:id=>@recebimento.paciente_id)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @recebimento.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /recebimentos/1
  # DELETE /recebimentos/1.xml
  def destroy
    @recebimento = Recebimento.find(params[:id])
    @recebimento.data_de_exclusao = Date.today
    @recebimento.observacao_exclusao = "."
    #TODO fazer exclusao de recebimento lembrando que é preciso excluir o respectivo cheque

    respond_to do |format|
      format.html { redirect_to(recebimentos_url) }
      format.xml  { head :ok }
    end
  end
  
  def relatorio
    #TODO fazer exclusao de recebimento, com formulario
    @formas_recebimento = FormasRecebimento.por_nome
    @tipos_recebimento = FormasRecebimento.por_nome.collect{|obj| [obj.nome, obj.id]}
     if params[:datepicker]
       @data_inicial = params[:datepicker].to_date
       @data_final = params[:datepicker2].to_date
     else
       @data_inicial = Date.today  - Date.today.day.days + 1.day
       @data_final = Date.today
     end
     formas_selecionadas = ""
     @formas_recebimento.each() do |forma|
       if params["forma_#{forma.id.to_s}"]
         formas_selecionadas += forma.id.to_s + ","
       end
     end
     @recebimentos = Recebimento.da_clinica(session[:clinica_id]).
               por_data.entre_datas(@data_inicial, @data_final).
               nas_formas(formas_selecionadas.split(",").to_a).
               nao_excluidos
     @recebimentos_excluidos = Recebimento.da_clinica(session[:clinica_id]).
                          por_data.entre_datas(@data_inicial, @data_final).
                          nas_formas(formas_selecionadas.split(",").to_a).
                          excluidos
  end
  
  def das_clinicas
    if params[:datepicker]
      inicio = params[:datepicker].to_date
      fim = params[:datepicker2].to_date
    else
      inicio = Date.today - 15.days
      fim = Date.today
      params[:datepicker] = inicio.to_s_br
      params[:datepicker2] = fim.to_s_br
    end
    @formas_recebimento = FormasRecebimento.por_nome
    @todas_as_clinicas = Clinica.todas.por_nome
    selecionadas = ""
    @todas_as_clinicas.each() do |clinica|
      if params["clinica_#{clinica.id.to_s}"]
       selecionadas += clinica.id.to_s + ","
      end      
    end
    formas_selecionadas = ""
    @formas_recebimento.each() do |forma|
      if params["forma_#{forma.id.to_s}"]
        formas_selecionadas += forma.id.to_s + ","
      end
    end
    @recebimentos = Recebimento.por_data.
       das_clinicas(selecionadas.split(",").to_a).
       entre_datas(inicio,fim).
       nas_formas(formas_selecionadas.split(",").to_a).
       nao_excluidos
  end
  
  def entradas_no_mes
    @data = Date.today
    @entradas = Array.new(32,0)
    @devolvidos = Array.new(32,0)
    @reapresentados = Array.new(32,0)
    @devolvido_duas_vezes = Array.new(32,0)
    if params[:date]
      @inicio = Date.new(params[:date][:year].to_i, params[:date][:month].to_i,1)
      @data = @inicio
      @fim = @inicio + 1.month - 1.day
      @recebimentos = Recebimento.da_clinica(session[:clinica_id]).entre_datas(@inicio,@fim)
      @recebimentos.each do |rec|
        if (!rec.em_cheque?) or (rec.em_cheque? && !rec.cheque.nil? ) #&& rec.cheque.limpo?)
          @entradas[rec.data.day] += rec.valor
        end
      end
      @cheques_devolvidos = Cheque.devolvidos(@inicio,@fim).nao_reapresentados.nao_excluidos
      @cheques_devolvidos.each do |chq|
        @devolvidos[chq.data_devolucao.day] += chq.valor
      end
      @cheques_reapresentados = Cheque.reapresentados(@inicio,@fim).nao_excluidos.sem_segunda_devolucao
      @cheques_reapresentados.each do |chq|
        @reapresentados[chq.data_reapresentacao.day] += chq.valor
      end
      @devolvidos_de_novo = Cheque.devolvido_duas_vezes_entre_datas(@inicio, @fim).nao_excluidos.sem_solucao
      @devolvidos_de_novo.each do |chq|
        @devolvido_duas_vezes[chq.data_segunda_devolucao.day] += chq.valor
      end
    end
  end

  protected
  
  def busca_bancos_e_forma_de_recebimento
    @bancos              = Banco.por_nome.collect{|obj| [obj.nome,obj.id]}
    @formas_recebimentos = FormasRecebimento.por_nome.collect{|obj| [obj.nome,obj.id]}
  end  
  
end
