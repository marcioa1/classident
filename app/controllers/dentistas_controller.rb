class DentistasController < ApplicationController
  layout "adm"
  before_filter :require_user
  before_filter :quinzena, :on=>:producao_geral
  before_filter :busca_dentista, :only=>[:abre, :desativar, :update, 
                   :destroy, :show, :edit, :troca_ortodontista]

  def index
    params[:ativo] = "true" if params[:ativo].nil?
    if @clinica_atual.administracao? 
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
        #FIXME Apagar o cache de dentistas da clinica
        # Rails.cache.clear
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
        #FIXME Apagar o cache de dentistas da clinica
        # Rails.cache.clear
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

  def troca_ortodontista
    if @dentista.ortodontista?
      @dentista.ortodontista = false
    else
      @dentista.ortodontista = true
    end
    @dentista.save
    # redirect_to(dentistas_path())
    head :ok
  end

  def abre
    @clinicas      = busca_clinicas #Clinica.all(:order=>:nome)
    @clinica_atual = Clinica.find(session[:clinica_id])
    quinzena
    @orcamentos    = Orcamento.do_dentista(@dentista.id)
#TODO fazer campo pagamento_id ao tratamento  

  end
  
  def producao
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
      inicio      = params[:datepicker].to_date if Date.valid?(params[:datepicker])
      fim         = params[:datepicker2].to_date if Date.valid?(params[:datepicker2])
      @producao   = dentista.busca_producao(inicio,fim,clinicas)
      @ortodontia = dentista.busca_producao_de_ortodontia(inicio,fim)
      render :partial=>'dentistas/producao_do_dentista', :locals=>{:producao=>@producao} 
    else
      @erros = ''
      @erros = "Data inicial inválida." if !Date.valid?(params[:datepicker])
      @erros += "Data final inválida." if !Date.valid?(params[:datepicker2])
    end
  
  end
  
  def pagamento
    inicio      = params[:inicio].to_date
    fim         = params[:fim].to_date
    @dentista   = Dentista.find(params[:dentista_id])
    @pagamentos = @dentista.pagamentos.entre_datas(inicio,fim).nao_excluidos
    render :partial => 'dentistas/pagamento_dentista', :locals=>{:pagamentos=>@pagamentos}
  end
  
  def pesquisar
    params[:ativo] = "true" if params[:ativo].nil?
     if @clinica_atual.administracao? 
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
    @orcamentos = Orcamento.do_dentista(dentista.id).entre_datas(inicio,fim)
    render :partial => 'dentistas/orcamentos', :locals=>{:orcamentos => @orcamentos}
  end
  
  def producao_geral
    if !params[:datepicker]
      quinzena
    else
      @data_inicial = params[:datepicker].to_date if Date.valid?(params[:datepicker])
      @data_final   = params[:datepicker2].to_date if Date.valid?(params[:datepicker2])
    end
    @clinicas    = Clinica.all
    clinicas_da_pesquisa = []
    if Date.valid?(params[:datepicker]) && Date.valid?(params[:datepicker2])
      @clinicas.each do |clinica|
        clinicas_da_pesquisa<< clinica.id if params["clinica_"+clinica.id.to_s]
      end
      debugger
      all = Tratamento.da_clinica(clinicas_da_pesquisa).dentistas_entre_datas(@data_inicial,@data_final)
      @todos = []
      all.each do |den|
        @todos << Dentista.find (den.dentista.id)
      end
      @todos.sort{|a,b| a[:nome] <=> b[:nome] }
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
