class RecebimentosController < ApplicationController
  
  layout "adm"
  
  before_filter :require_user
  before_filter :verifica_horario_de_trabalho
  before_filter :busca_bancos_e_forma_de_recebimento, :only=>[:new, :edit]
  before_filter :busca_recebimento, :only => [:show,  :edit, :update, :exclui, :destroy, :exclusao]
  before_filter :salva_action_na_session
  before_filter :verifica_se_tem_senha
  
  
  def index
    @recebimentos = Recebimento.all(:limit=> 50,:order => 'created_at desc')
  end

  def show
  end

  def new
    @recebimento             = Recebimento.new
    @recebimento.cheque      = Cheque.new
    @recebimento.formas_recebimento_id = FormasRecebimento.cheque_id
    @paciente                = Paciente.find(params[:paciente_id])
    @recebimento.paciente    = @paciente
    @recebimento.clinica_id  = @paciente.clinica_id
    
  end

  def edit
    @cheque    = @recebimento.cheque
    @paciente  = @recebimento.paciente
    @recebimento.cheque = Cheque.new if @recebimento.cheque.nil?
  end

  def create
    #FIXME reescrever, método muito grande
    @recebimento      = Recebimento.new(params[:recebimento])
    @recebimento.percentual_dentista = 0 if @recebimento.percentual_dentista.nil?
    if !na_quinzena?(@recebimento.data)
      @recebimento.errors.add(:data, " : não pode ser anterior à quinzena")
    elsif @recebimento.em_cheque?
      if !Recebimento::FORMATO_VALIDO_BR.match(params[:valor_do_cheque])
        @recebimento.errors.add("Formato do cheque inválido!")
      else
        @cheque                 = monta_cheque
        @recebimento.cheque     = @cheque
        @recebimento.errors.add(:banco, 'não pode ser branco') if !@cheque.banco.present?
        @recebimento.errors.add(:numero, 'do cheque não pode ser branco') if !@cheque.numero.present?
        @recebimento.errors.add(:valor, ' do cheque não pode ser branco') if !@cheque.valor.present?
      end
      if params[:paciente_id_2].present?
        if !Recebimento::FORMATO_VALIDO_BR.match(params[:valor_segundo_paciente])
          @recebimento.errors.add("Formato do valor do segundo paciente ")
       else
         @recebimento2                       = Recebimento.new
         @recebimento2.percentual_dentista   = @recebimento.percentual_dentista
         @recebimento2.paciente_id           = params[:paciente_id_2]
         @recebimento2.valor                 = params[:valor_segundo_paciente].gsub('.','').gsub(',','.')
         @recebimento2.observacao            = params[:observacao_paciente_2]
         @recebimento2.formas_recebimento_id = @recebimento.formas_recebimento_id
         @recebimento2.data                  = @recebimento.data
         @recebimento2.clinica_id            = session[:clinica_id]
         @recebimento2.cheque                = @cheque
       end
     end
      if params[:paciente_id_3].present?
        if !Recebimento::FORMATO_VALIDO_BR.match(params[:valor_terceiro_paciente])
          @recebimento.errors.add("Formato do valor do segundo paciente ")
        else
          @recebimento3                       = Recebimento.new
          @recebimento3.percentual_dentista   = @recebimento.percentual_dentista
          @recebimento3.paciente_id           = params[:paciente_id_3]
          @recebimento3.valor                 = params[:valor_terceiro_paciente].gsub('.','').gsub(',','.')
          @recebimento3.observacao            = params[:observacao_paciente_3]
          @recebimento3.formas_recebimento_id = @recebimento.formas_recebimento_id
          @recebimento3.data                  = @recebimento.data
          @recebimento3.clinica_id            = session[:clinica_id]
          @recebimento3.cheque                = @cheque
        end
      end
    else
      @cheque = nil
    end
    
    Recebimento.transaction do
      if (@recebimento.errors.size==0) && ((@recebimento.em_cheque? && @cheque.valid?) || (!@recebimento.em_cheque?))
        @cheque.save if @cheque
        debugger
        @recebimento.save 
        @recebimento2.save if @recebimento2
        @recebimento3.save if @recebimento3
        @recebimento.verifica_fluxo_de_caixa
        (2..params[:numero_de_cheques].to_i).each do |num|
          outro_cheque             = @cheque.clone
          outro_cheque.bom_para    = @cheque.bom_para + (num-1).month
          outro_cheque.numero      = @cheque.numero
          (1..num-1).each do |suc|
            outro_cheque.numero    = outro_cheque.numero.succ
          end
          outro_cheque.save
          outro_recebimento        = @recebimento.clone
          outro_recebimento.cheque = outro_cheque
          outro_recebimento.data   = @recebimento.data + (num-1).month
          outro_recebimento.save
          if @recebimento2
            outro_recebimento        = @recebimento2.clone
            outro_recebimento.data   = @recebimento2.data + (num-1).month
            outro_recebimento.cheque = outro_cheque
            outro_recebimento.save
          end
          if @recebimento3
            outro_recebimento      = @recebimento3.clone
            outro_recebimento.data = @recebimento3.data + (num-1).month
            outro_recebimento.cheque = outro_cheque
            outro_recebimento.save
          end
          
        end
        redirect_to(abre_paciente_path(:id=>@recebimento.paciente_id)) 
      else
        @paciente = Paciente.find(session[:paciente_id])
        @bancos   = Banco.all(:order=>:nome).collect{|obj| [obj.numero + " - " + obj.nome,obj.id.to_s]}
        @formas_recebimentos = FormasRecebimento.por_nome.collect{|obj| [obj.nome,obj.id]}
        render :action => "new" 
      end
    end #transaction
  end

  def update
    if !@recebimento.na_quinzena?
      @recebimento.errors.add(:data, " : não pode ser anterior à quinzena")
    elsif @recebimento.em_cheque? && @recebimento.cheque
      # @recebimento.data_pr_br             = params[:datepicker].to_date
      # @recebimento.valor_real             = params[:recebimento_valor_real]
      @recebimento.observacao             = params[:observacao]
      @cheque                             = @recebimento.cheque
      @cheque.bom_para        = params[:datepicker2].to_date
      @cheque.banco_id        = params[:banco_id]
      @cheque.agencia         = params[:agencia]
      @cheque.numero          = params[:numero]
      @cheque.conta_corrente  = params[:conta_corrente]
      @cheque.valor           = params[:valor_cheque].gsub('.','').gsub(',','.')
      @cheque.add(:banco, 'não pode ser branco') if !@recebimento.cheque.banco.present?
      @cheque.add(:numero, 'do cheque não pode ser branco') if !@recebimento.cheque.numero.present?
      @cheque.add(:valor, ' do cheque não pode ser branco') if !@recebimento.cheque.valor.present?
    else
      @recebimento.cheque = nil
    end

    if @recebimento.update_attributes(params[:recebimento]) 
      @recebimento.verifica_fluxo_de_caixa
      
      if @recebimento.em_cheque? && @recebimento.cheque
        @cheque.save
      end
      #TODO fazer redirect_to back votlar para a presquisa feita com dados
      # redirect_to :back
      redirect_to(abre_paciente_path(:id=>@recebimento.paciente_id)) 
    else
      render :action => "edit" 
    end
  end

  def destroy
  end
  
  def exclui
    @recebimento.exclui(current_user.id, params[:observacao_exclusao])
    redirect_to(abre_paciente_path(@recebimento.paciente))
  end
  
  def exclusao
    @paciente = @recebimento.paciente
  end
  
  def relatorio
    @formas_recebimento = FormasRecebimento.por_nome
    if !params[:datepicker]
      params[:datepicker2] = Date.today.to_s_br
      params[:datepicker]  = (Date.today - 15.days).to_s_br
    end
    if Date.valid?(params[:datepicker]) && Date.valid?(params[:datepicker2])
      @data_inicial = params[:datepicker].to_date
      @data_final   = params[:datepicker2].to_date
      @erros        = ''
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
     forma_cheque_id = FormasRecebimento.find_by_nome('cheque').id
    else
      @erros = ''
      @erros = "Data inicial inválida." if !Date.valid?(params[:datepicker])
      @erros += "Data final inválida." if !Date.valid?(params[:datepicker2])
      @recebimentos           = []
      @recebimentos_excluidos = []
    end
    # if formas_selecionadas.include?(forma_cheque_id.to_s)
    #   @recebimentos_devolvidos = Recebimento.em_cheque.com_problema.entre_datas(@data_inicial,@data_final)
    #   @recebimentos = @recebimentos - @recebimentos_devolvidos 
    # end
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
    @data                 = Date.today
    @entradas             = Array.new(32,0)
    @devolvidos           = Array.new(32,0)
    @reapresentados       = Array.new(32,0)
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
        @devolvidos[chq.data_primeira_devolucao.day] += chq.valor
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

  def pesquisa_nomes
     nomes = Paciente.all(:select=>'id,nome', :conditions=>["nome like ? and clinica_id = ? ", "#{params[:term].nome_proprio}%", session[:clinica_id] ])  
     result = []
     nomes.each do |nome|
       result << nome.nome
     end
     render :json => result.to_json
   end

  protected
  
  def monta_cheque
    @cheque                 = Cheque.new
    @cheque.bom_para        = params[:datepicker2].to_date
    @cheque.clinica_id      = session[:clinica_id]
    @cheque.banco_id        = params[:banco_id]
    @cheque.agencia         = params[:agencia]
    @cheque.numero          = params[:numero]
    @cheque.conta_corrente  = params[:conta_corrente]
    @cheque.valor           = params[:valor_do_cheque].gsub('.','').gsub(',','.')
    @cheque
  end
  
  def busca_bancos_e_forma_de_recebimento
    @bancos              = Banco.por_nome.collect{|obj| [obj.nome,obj.id]}
    @formas_recebimentos = FormasRecebimento.por_nome.collect{|obj| [obj.nome,obj.id]}
  end  

  def busca_recebimento
    @recebimento = Recebimento.find(params[:id])
  end  
  
end
