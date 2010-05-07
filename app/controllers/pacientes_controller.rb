class PacientesController < ApplicationController
  layout "adm"
  before_filter :require_user
  before_filter :busca_paciente, :only =>[:edit, :show, :update]
  
  def index
    @pacientes = Paciente.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pacientes }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @paciente }
    end
  end

  def new
    if administracao?
      redirect_to administracao_path
    else
      @tabelas       = Tabela.ativas.collect{|obj| [obj.nome,obj.id]}
      @paciente      = Paciente.new
      @indicacoes    = Indicacao.por_descricao.collect{|obj| [obj.descricao, obj.id]}
      @ortodontistas = Dentista.ortodontistas.collect{|obj| [obj.nome,obj.id]}
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @paciente }
      end
    end
  end

  def edit
    @indicacoes = Indicacao.por_descricao.collect{|obj| [obj.descricao, obj.id]}
  end

  def create
    @paciente = Paciente.new(params[:paciente])
    @paciente.clinica_id = session[:clinica_id]
    @paciente.codigo = @paciente.gera_codigo(session[:clinica_id])
    @paciente.inicio_tratamento = params[:datepicker2].to_date
    @paciente.data_da_suspensao_da_cobranca_de_orto = parasm[:datepicker3].to_date unless params[:datepicker3].blank?
    @paciente.data_da_saida_da_lista_de_debitos = params[:datepicker4].to_date unless params[:datepicker4].blank?
    respond_to do |format|
      if @paciente.save
        format.html { redirect_to(pesquisa_pacientes_path) }
        format.xml  { render :xml => @paciente, :status => :created, :location => @paciente }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @paciente.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @paciente.inicio_tratamento = params[:datepicker2].to_date
    @paciente.data_da_suspensao_da_cobranca_de_orto = parasm[:datepicker3].to_date unless params[:datepicker3].blank?
    @paciente.data_da_saida_da_lista_de_debitos = params[:datepicker4].to_date unless params[:datepicker4].blank?
    respond_to do |format|
      if @paciente.update_attributes(params[:paciente])
        format.html { redirect_to(abre_paciente_path(:id=>@paciente.id)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @paciente.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @paciente.destroy

    respond_to do |format|
      format.html { redirect_to(pacientes_url) }
      format.xml  { head :ok }
    end
  end
  
  def pesquisa
    params[:nome]         = params[:nome].nome_proprio if params[:nome]
    session[:paciente_id] = nil
    # if !session[:paciente_id].nil?
    #   @paciente       = Paciente.find(session[:paciente_id])
    #   params[:codigo] = @paciente.id
    #   params[:nome]   = @paciente.nome
    # end  
    @pacientes = []
    if !params[:codigo].blank?
      if administracao?
        @pacientes = Paciente.all(:conditions=>["codigo=?", params[:codigo]], :order=>:nome)
      else
        @pacientes = Paciente.all(:conditions=>["clinica_id=? and codigo=?", session[:clinica_id].to_i, params[:codigo].to_i],:order=>:nome)
      end
      if !@pacientes.empty?
        if @pacientes.size==1
          redirect_to abre_paciente_path(:id=>@pacientes.first.id)
        else
        end 
      else
        flash[:notice] =  'Não foi encontrado paciente com o código ' + params[:codigo]
        render :action=> "pesquisa"
      end
    else
      if params[:nome]
        if administracao?
          @pacientes = Paciente.all(:conditions=>["nome like ?", params[:nome] + '%'],:order=>:nome)
        else
          @pacientes = Paciente.all(:conditions=>["clinica_id= ? and nome like ?", session[:clinica_id].to_i, params[:nome] + '%'],:order=>:nome)
        end
      end 
    end 
  end
  
  
  def pesquisa_nomes
    nomes = Paciente.all(:select=>'nome', :conditions=>["nome like ?", "#{params[:term].nome_proprio}%" ])  
    render :json => nomes.map(&:nome).to_json
  end
  
  def abre
    if params[:nome]
      @paciente = Paciente.find_by_nome(params[:nome])
    else
      @paciente = Paciente.find(params[:id])
    end
    @tabelas = Tabela.ativas.collect{|obj| [obj.nome,obj.id]}
    @indicacoes = Indicacao.por_descricao.collect{|obj| [obj.descricao, obj.id]}
    @pendentes_protetico = TrabalhoProtetico.pendentes.do_paciente(@paciente.id)
    @devolvidos_protetico = TrabalhoProtetico.devolvidos.do_paciente(@paciente.id) 
    @orcamentos = @paciente.orcamentos
    @ortodontistas = Dentista.ortodontistas.por_nome.collect{|obj| [obj.nome,obj.id]}
    
    session[:paciente_id] = @paciente.id
    session[:paciente_nome] = @paciente.nome
  end
  
  def nova_alta
    @alta = Alta.new(:paciente_id => id)
  end
  
  def create_alta
    
  end
  
  def nomes_que_iniciam_com
    if params[:nome]
      if administracao?
        @pacientes = Paciente.all(:conditions=>["nome like ?", params[:nome] + '%'],:order=>:nome)
      else
        @pacientes = Paciente.all(:conditions=>["clinica_id= ? and nome like ?", session[:clinica_id].to_i, params[:nome] + '%'],:order=>:nome)
      end
    end 
    result = ''
    @pacientes.each do |pac|
      result += '<a href= "#" onclick="javascript:escolheu_nome_da_lista(\''+pac.nome+'\',' + '\'' + params[:div] + '\',' + pac.id.to_s + ')" >'+ pac.nome + "</a><br/>"
    end
    result += ''
    render :json => result.to_json
  end

  def busca_paciente
    @paciente = Paciente.find(params[:id])
  end  

end
