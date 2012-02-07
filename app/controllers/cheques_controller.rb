class ChequesController < ApplicationController

  layout "adm", :except => :show
  
  before_filter :require_user
  before_filter :salva_action_na_session
  before_filter :verifica_se_tem_senha
  before_filter :find_current, :only => [:grava_destinacao, :show, :edit, :udpate,
                      :destroy, :reverte_cheque, :recebe_da_administracao,
                      :devolve_a_clinica, :tornar_disponivel, :envia_a_administracao,
                      :envia_ao_cofre, :entra_no_cofre, :sai_do_cofre, 
                      :recebe_do_cofre, :reverte_do_cofre]

  def index
    @cheques = Cheque.all

  end

  def show
  end

  def edit
    @bancos = Banco.all(:order=>:nome).collect{|obj| [obj.nome,obj.id]}
    @destinacoes = Destinacao.all(:conditions=>["clinica_id = ? and ativa = ?", session[:clinica_id], true], :order=>:nome).collect{|d| [d.nome,d.id]}
    # session[:origem] = edit_cheque_path(@cheque)
  end

  def update
    @cheque = Cheque.find(params[:id])
    valor_anterior = @cheque.valor
    if params[:datepicker2].empty?
      @cheque.data_primeira_devolucao = nil
    else
      @cheque.data_primeira_devolucao = params[:datepicker2].to_date
    end
    if params[:datepicker3].empty?
      @cheque.data_reapresentacao = nil
    else
      @cheque.data_reapresentacao = params[:datepicker3].to_date
    end
    if @cheque.update_attributes(params[:cheque])
      if valor_anterior != @cheque.valor
        @cheque.recebimentos.first.update_attribute(:valor, @cheque.valor)
      end
      redirect_to( session[:origem].present? ? session[:origem] : :back  ) 
    else
      @bancos = Banco.all(:order=>:nome).collect{|obj| [obj.nome,obj.id]}
      @destinacoes = Destinacao.all(:conditions=>["clinica_id = ? and ativa = ?", session[:clinica_id], true], :order=>:nome).collect{|d| [d.nome,d.id]}

      render :action => "edit" 
    end
  end

  def destroy
    @cheque.destroy

    redirect_to(cheques_url) 
  end
  
  def cheques_recebidos
    params[:ordem]   = 'por_data' if params[:ordem].nil?
    session[:origem] = cheques_recebidos_cheques_path
    @destinacoes     = Destinacao.all(:conditions=>["clinica_id = ? and ativa = ?", session[:clinica_id], true], :order=>:nome).collect{|d| [d.nome,d.id]}.insert(0,'')

    @clinicas = Clinica.todas.da_classident.por_nome if @clinica_atual.administracao?
    if params[:datepicker] && Date.valid?(params[:datepicker])
      @data_inicial = params[:datepicker].to_date
    else
      @data_inicial = Date.today - Date.today.day.days + 1.day
    end
    if params[:datepicker2] && Date.valid?(params[:datepicker2])
      @data_final = params[:datepicker2].to_date
    else
      @data_final = Date.today
    end
    lista_de_status = "todos,disponíveis,devolvido 2 vezes,usados para pagamento,destinação," + 
      "devolvido,reapresentado,spc,solucionado,enviados à administração," +
      "recebidos pela administração,devolvidos à clínica,recebidos pela clínica," +
      "arquivo morto,"
    @status = lista_de_status.split(",")
    
    if @clinica_atual.administracao?
      @status << ["enviados ao cofre"]
      @status << ["recebidos no cofre"]
      @status << ["devolvidos pelo cofre"]
      @status << ["recebidos do cofre p/ adm"]
      selecionadas = []
      @clinicas.each do |clinica|
        selecionadas << clinica.id if params["clinica_#{clinica.id}".to_sym]
      end
    end
    @cheques = Cheque.pesquisa(params[:status], @data_inicial, @data_final, selecionadas, session[:clinica_id], params[:ordem])
    @cheques = [] if @cheques.nil?
    @titulo  = "Lista de cheques entre #{@data_inicial.to_s_br}e #{@data_final.to_s_br} , #{params[:status]}"
  end
  
  def envia_cheques_a_administracao
    lista = params[:cheques].split(",")
    lista.each() do |numero|
      id      = numero.split("_")
      cheque  = Cheque.find(id[1].to_i)
      cheque.envia_cheque_a_administracao(session[:clinica_id], current_user)
    end
    render :json => (lista.size.to_s  + " cheques recebidos.").to_json
  end

  def confirma_recebimento
    if params[:ordem] == 'data'
      @cheques  = Cheque.vindo_da_clinica(params[:clinica]).entregues_a_administracao.nao_recebidos.por_bom_para
    else
      @cheques  = Cheque.vindo_da_clinica(params[:clinica]).entregues_a_administracao.nao_recebidos.por_valor
    end
    @clinicas = Clinica.todas.da_classident 
  end
  
  def registra_recebimento_de_cheques
    lista = params[:cheques].split(",")
    lista.each() do |numero|
      cheque = Cheque.find(numero.to_i)
      cheque.confirma_recebimento_na_administracao(session[:clinica_id], current_user)
    end
    render :json => (lista.size.to_s  + " cheques recebidos.").to_json
  end
  
  def recebimento_confirmado
    if params[:datepicker]
      @inicio = params[:datepicker].to_date
      @fim = params[:datepicker2].to_date
      @cheques = Cheque.recebidos_na_administracao(params[:datepicker].to_date,
                     params[:datepicker2].to_date)
   else
     @inicio = Date.today - 15.days
     @fim = Date.today
      @cheques = []
    end
  end
  
  def busca_disponiveis
    valor    = params[:valor].gsub('.', '').gsub(',','.')
    bom_para = params[:bom_para].present? ? params[:bom_para].to_date : Date.today

    if @clinica_atual.administracao?
      @cheques = Cheque.disponiveis_na_administracao.por_valor.menores_ou_igual_a(valor).entre_datas(Date.new(2011,01,01),bom_para);
    else
      @cheques = Cheque.da_clinica(session[:clinica_id]).disponiveis_na_clinica.por_valor.menores_ou_igual_a(valor).entre_datas(Date.new(2011,01,01),bom_para);
    end
    @cheques = @cheques.all(:limit => 11150)
    render :partial => 'cheques_disponiveis', :locals=>{:cheques => @cheques}
  end
  
  def pesquisa
    @bancos = Banco.por_nome.collect{|obj| [obj.numero.to_s + '-'+ obj.nome, obj.id.to_s]}
    @cheques = []
    scope_valor   = ""
    scope_banco   = ""
    scope_agencia = ""
    scope_numero  = ""
    scope_data    = ""
    scope_clinica = ""
    # params[:ano] = Date.today.year if !params[:ano]
      if !params[:valor].blank?
        scope_valor = ".do_valor(#{params[:valor].gsub(",",".")})"
      end
      if params[:agencia] && !params[:agencia].blank?
        scope_agencia = ".da_agencia('#{params[:agencia]}')"
      end
      if params[:numero] && !params[:numero].blank?
        scope_numero = ".com_numero('#{params[:numero]}')"
      end
      if params[:banco] && !params[:banco].blank?
        scope_banco = ".do_banco('#{params[:banco]}')"
      end
      if params[:ano].present?
        data_inicial = params[:ano].to_s + '-01-01'
        data_final   = params[:ano].to_s + '-12-31'
        scope_data   = ".entre_datas('#{data_inicial}', '#{data_final}')"
      end
      if session[:clinica_id] != Clinica::ADMINISTRACAO_ID
        scope_clinica = ".da_clinica(#{session[:clinica_id]})"
      end
      scope_geral = scope_agencia + scope_numero + scope_banco + 
                    scope_data  + scope_valor
      # raise scope_geral
      if scope_geral.blank?
        @cheques = []
      else
        @cheques = eval("Cheque"+scope_geral+scope_clinica)
      end
  end
  
  def confirma_recebimento_na_administracao
    cheque = Cheque.find(params[:id])
    cheque.confirma_recebimento_na_administracao(session[:clinica_id], current_user)
    head :ok
  end

  def reverte_cheque
    @cheque.update_attribute(:data_entrega_administracao, nil)
    head :ok
  end

  def devolve_a_clinica
    @cheque.devolve_a_clinica(session[:clinica_id], current_user)
    head :ok
  end

  def recebe_da_administracao
    @cheque.recebe_da_administracao(session[:clinica_id], current_user)
    head :ok
  end  
  
  def grava_destinacao
    @cheque.registra_destinacao(session[:clinica_id], current_user, params[:destinacao_id])
    head :ok
  end

  def tornar_disponivel
    @cheque.registra_disponivel(session[:clinica_id], current_user)
    head :ok
  end

  def envia_a_administracao
    @cheque.envia_cheque_a_administracao(session[:clinica_id], current_user)
    head :ok
  end
  
  def envia_ao_cofre
    @cheque.envia_ao_cofre(current_user)
    head :ok
  end

  def entra_no_cofre
    @cheque.entra_no_cofre(current_user)
    head :ok
  end

  def sai_do_cofre
    @cheque.sai_do_cofre(current_user)
    head :ok
  end

  def recebe_do_cofre
    @cheque.recebe_do_cofre(current_user)
    head :ok
  end

  def reverte_do_cofre
    @cheque.reverte_do_cofre(current_user)
    head :ok
  end
  
  def find_current
    puts "----------------------"
    puts "passou pelo find_current"
    @cheque = Cheque.find(params[:id])
  end
end
