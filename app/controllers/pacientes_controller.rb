class PacientesController < ApplicationController
  layout "adm"
  before_filter :require_user
  before_filter :busca_paciente, :only =>[:edit, :show, :update]
  before_filter :busca_tabelas
  
  def index
    @pacientes = Paciente.all
  end

  def show
  end

  def new
    if @administracao
      redirect_to administracao_path
    else
      @paciente      = Paciente.new(:inicio_tratamento => Date.current)
    end
  end

  def edit
    @indicacoes = Indicacao.por_descricao.collect{|obj| [obj.descricao, obj.id]}
  end

  def create
    @paciente                   = Paciente.new(params[:paciente])
    @paciente.clinica_id        = session[:clinica_id]
    @paciente.codigo            = @paciente.gera_codigo(session[:clinica_id])
    @paciente.data_da_suspensao_da_cobranca_de_orto = parasm[:datepicker3].to_date unless params[:datepicker3].blank?
    @paciente.data_da_saida_da_lista_de_debitos     = params[:datepicker4].to_date unless params[:datepicker4].blank?
    if @paciente.save
      redirect_to(abre_paciente_path(@paciente)) 
    else
      render :action => "new" 
    end
  end

  def update
    @paciente.data_da_suspensao_da_cobranca_de_orto = params[:datepicker3].to_date if Date.valid?(params[:datepicker3])
    @paciente.data_da_saida_da_lista_de_debitos     = params[:datepicker4].to_date if Date.valid?(params[:datepicker4])
    if @paciente.update_attributes(params[:paciente])
      redirect_to(abre_paciente_path(:id=>@paciente.id)) 
    else
      # render :edit
      #FIXME Verificar validação de email e redirecionar para o _edit
      render :partial=>"edit"
    end
  end

  def destroy
    @paciente.destroy

    redirect_to(pacientes_url) 
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
      if administracao
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
        if administracao
          @pacientes = Paciente.all(:conditions=>["nome like ?", params[:nome] + '%'],:order=>:nome)
        else
          @pacientes = Paciente.all(:conditions=>["clinica_id= ? and nome like ?", session[:clinica_id].to_i, params[:nome] + '%'],:order=>:nome)
        end
      end 
    end 
  end
  
  
  def pesquisa_nomes
    if administracao
      nomes = Paciente.all(:select=>'nome,clinica_id', :conditions=>["nome like ?", "#{params[:term].nome_proprio}%" ])  
    else
      nomes = Paciente.all(:select=>'nome,clinica_id', :conditions=>["nome like ? and clinica_id = ? ", "#{params[:term].nome_proprio}%", session[:clinica_id] ])  
    end
    result = []
    nomes.each do |nome|
      if administracao
        result << nome.nome + ', ' + Clinica.find(nome.clinica_id).sigla
      else
        result << nome.nome 
      end      
    end
    render :json => result.to_json
  end
  
  def abre
    if params[:nome]
      nome_sem_clinica = params[:nome].split(',')[0].strip
      @paciente = Paciente.find_by_nome(nome_sem_clinica)
    else
      @paciente = Paciente.find(params[:id])
    end
    @indicacoes           = Indicacao.por_descricao.collect{|obj| [obj.descricao, obj.id]}
    session[:paciente_id]   = @paciente.id
    session[:paciente_nome] = @paciente.nome
    debugger
    @tab_index = session[:tab_paciente]
  end
  
  def nova_alta
    @alta = Alta.new(:paciente_id => id)
  end
  
  def create_alta
    
  end
  
  def nomes_que_iniciam_com
    if params[:nome]
      if @administracao
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

  def busca_id_do_paciente
    paciente_id = Paciente.find_by_nome(params[:nome]).id
    render :json => paciente_id.to_json
  end

  def busca_paciente
    @paciente = Paciente.find(params[:id])
  end  

  def busca_tabelas
    @tabelas    = Tabela.ativas.collect{|obj| [obj.nome,obj.id]}
    @indicacoes = Indicacao.por_descricao.collect{|obj| [obj.descricao, obj.id]}
    @ortodontistas        = Dentista.ortodontistas.por_nome.collect{|obj| [obj.nome,obj.id]}
  end

end
