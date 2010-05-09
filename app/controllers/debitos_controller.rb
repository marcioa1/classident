class DebitosController < ApplicationController
  layout "adm"

  def index
    @debitos = Debito.all
  end

  def show
    @debito = Debito.find(params[:id])
  end

  def new
    @debito = Debito.new
    @debito.paciente_id = params[:paciente_id]
  end

  def edit
    @debito = Debito.find(params[:id])
  end

  def create
    @debito = Debito.new(params[:debito])
    @debito.data = params[:datepicker].to_date
    if @debito.save
      redirect_to(abre_paciente_path(:id=>@debito.paciente_id)) 
    else
      render :action => "new" 
    end
  end

  def update
    @debito = Debito.find(params[:id])

    if @debito.update_attributes(params[:debito])
       redirect_to(abre_paciente_path(:id=>@debito.paciente_id)) 
    else
      render :action => "edit" 
    end
  end

  def destroy
    @debito = Debito.find(params[:id])
    @debito.destroy

    redirect_to(abre_paciente_path(:id=>@debito.paciente_id)) 
  end
  
  def pacientes_em_debito
    if params[:tipo] == 'ortodontia'
      @pacientes = Paciente.da_clinica(session[:clinica_id]).por_nome.de_ortodontia
    else
      @pacientes = Paciente.da_clinica(session[:clinica_id]).por_nome.de_clinica
    end
    @em_debito = []
    @tabelas = Tabela.ativas.por_nome
    @pacientes.each do |pac|
      if params['tabela_' + pac.tabela_id.to_s]
        puts pac.nome + " > " + pac.saldo.real.to_s
        @em_debito << pac if pac.em_debito?
      end
    end
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
  end
end
