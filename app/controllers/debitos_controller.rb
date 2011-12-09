class DebitosController < ApplicationController
  layout "adm"
  
  before_filter :require_user
  before_filter :busca_corrente, :only=>[:show, :edit, :update, :destroy, :cancela]

  def index
    @debitos = Debito.all
  end

  def show
  end

  def new
    @debito             = Debito.new
    @debito.paciente_id = params[:paciente_id]
    @paciente           = Paciente.find(params[:paciente_id])
  end

  def edit
    @paciente           = @debito.paciente
  end

  def create
    @debito      = Debito.new(params[:debito])
    @debito.clinica_id = session[:clinica_id]
    if @debito.save
      redirect_to(abre_paciente_path(:id=>@debito.paciente_id)) 
    else
      render :action => "new" 
    end
  end

  def update
    if @debito.update_attributes(params[:debito])
       redirect_to(abre_paciente_path(:id=>@debito.paciente_id)) 
    else
      @paciente = @debito.paciente
      render :action => "edit" 
    end
  end

  def destroy
    if @debito.pode_excluir? || @current_user.master?
      @debito.update_attribute(:data_de_exclusao, Date.today)

      redirect_to(abre_paciente_path(:id=>@debito.paciente_id)) 
    end
  end
  
  def pacientes_em_debito
    if params[:tipo] == 'ortodontia'
      @pacientes = Paciente.da_clinica(session[:clinica_id]).por_nome.de_ortodontia
    else
      @pacientes = Paciente.da_clinica(session[:clinica_id]).por_nome.de_clinica
    end
    @em_debito = []
    @tabelas   = Tabela.ativas.por_nome.da_clinica(session[:clinica_id])
    @pacientes.each do |pac|
      if params['tabela_' + pac.tabela_id.to_s]
        @em_debito << pac if pac.em_debito?
      end
    end
    @titulo = "Pacientes em débito da clínica #{@clinica_atual.nome}"
  end
  
  def pacientes_fora_da_lista
    if params[:datepicker]
      @data_inicial = params[:datepicker].to_date
      @data_final = params[:datepicker2].to_date
    else
      @data_inicial = Date.today - 1.month
      @data_final = Date.today
    end
    @pacientes = Paciente.fora_da_lista_de_debito_entre(@data_inicial, @data_final).da_clinica(session[:clinica_id])
    @titulo = "Pacientes fora da lista de débito entre #{@data_inicial.to_s_br} e #{@data_final.to_s_br} da clínica #{@clinica_atual.nome}"

  end
  
  def cancela
    @debito.update_attribute("cancelado", !@debito.cancelado?)
    redirect_to :back
  end
  
  private
  
  def busca_corrente
    @debito = Debito.find(params[:id])
  end
  
end
