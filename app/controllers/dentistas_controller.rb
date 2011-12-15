class DentistasController < ApplicationController
  layout "adm"
  before_filter :require_user
  before_filter :quinzena, :on=>:producao_geral
  before_filter :busca_dentista, :only=>[:abre, :desativar, :update, 
                   :destroy, :show, :edit, :reativar, :troca_ortodontista]

  def index
    params[:ativo] = "true" if params[:ativo].nil?
    if @clinica_atual.administracao? 
      if params[:ativo]=="true"
        @dentistas = Dentista.da_classident.por_nome.ativos
      else
        @dentistas = Dentista.da_classident.por_nome.inativos
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
    @clinicas = Clinica.todas.da_classident.por_nome
  end

  def edit
    @clinicas = busca_clinicas 
  end

  def create
    @dentista = Dentista.new(params[:dentista])
    @dentista.clinicas = []
    clinicas = busca_clinicas 
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
    clinicas = busca_clinicas 
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
    @clinicas      = busca_clinicas 
    @clinica_atual = Clinica.find(session[:clinica_id])
    quinzena
    @orcamentos    = Orcamento.do_dentista(@dentista.id)

  end
  
  def producao
    @dentista = Dentista.find(params[:id])
    if !params[:datepicker]
      quinzena
      params[:datepicker]  = @data_inicial.to_s_br
      params[:datepicker2] = @data_final.to_s_br
    end
    if params[:clinicas]
      clinicas = params[:clinicas].split(",").to_a
      nome_das_clinicas = Clinica.all(:conditions => ["id in (?)", clinicas]).map(&:nome).join(',')
    else
      clinicas = session[:clinica_id].to_a
      nome_das_clinicas = ''
    end
    if Date.valid?(params[:datepicker]) && Date.valid?(params[:datepicker2])
      inicio      = params[:datepicker].to_date if Date.valid?(params[:datepicker])
      fim         = params[:datepicker2].to_date if Date.valid?(params[:datepicker2])
      @producao   = @dentista.busca_producao(inicio,fim,clinicas)
      @ortodontia = @dentista.ortodontista? ? @dentista.busca_producao_de_ortodontia(inicio,fim) : []
      @titulo     = "#{nome_das_clinicas} \n#{@dentista.nome}\nProdutividade entre : #{inicio.to_s_br} e #{fim.to_s_br} "
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
    if !params[:data_inicial]
      quinzena
    else
      @data_inicial = params[:data_inicial].to_date if Date.valid?(params[:data_inicial])
      @data_final   = params[:data_final].to_date if Date.valid?(params[:data_final])
    end
    @clinicas    = Clinica.da_classident.sem_administracao
    @clinicas_da_pesquisa = []
    if Date.valid?(params[:data_inicial]) && Date.valid?(params[:data_final])
      @clinicas.each do |clinica|
        @clinicas_da_pesquisa<< clinica.id if params["clinica_"+clinica.id.to_s]
      end
      all = Tratamento.da_clinica(@clinicas_da_pesquisa).dentistas_entre_datas(@data_inicial,@data_final)
      @todos = []
      all.each do |den|
        dentista =  Dentista.find(den.dentista.id) 
        @todos << dentista if dentista.ativo?
      end
      @clinicas_da_pesquisa.each do |cli|
        Clinica.find(cli).ortodontistas.each do |orto|
          dentista = Dentista.find(orto)
          @todos << dentista if dentista.ativo?
        end
      end
      @todos.sort{|a,b| a[:nome] <=> b[:nome] }
    else
      @todos = []
      @erros = ''
      @erros = "Data inicial inválida." if params[:data_inicial] && !Date.valid?(params[:data_inicial])
      @erros += "Data final inválida." if params[:data_final] && !Date.valid?(params[:data_final])
    end
    # Dentista.ativos.por_nome
  end
  
  def imprime_producao_detalhada
    # raise params[:ids].inspect
    require 'prawn/core'
    require "prawn/layout"
 
    verify_existence_of_directory
    @nome_da_clinica = Clinica.find(params[:clinicas]).first.nome
    @data_inicial = params[:data_inicial]
    @data_final   = params[:data_final]
    Prawn::Document.generate(File.join(Rails.root , "impressoes/#{session[:clinica_id]}/producao_detalhada.pdf"), 
       :page_layout => :landscape) do |pdf|
        pdf.repeat :all do
          pdf.text "#{Time.current.to_s_br}", :align => :right, :size=>8, :vposition => 10
          pdf.bounding_box [10, 540], :width  => pdf.bounds.width do
            pdf.font "Helvetica"
            pdf.text "#{@nome_da_clinica} - período #{@data_inicial.to_date.to_s_br} a #{@data_final.to_date.to_s_br}", :align => :center, :size => 14, :vposition => -20
          end
          pdf.horizontal_line 2, 850, :at => 520
          pdf.stroke
        end
     dentistas = params[:ids].split(',')
     dentistas.each do |dentista|
        @dentista = Dentista.find(dentista.to_i)
        pdf.font_size = 14
        pdf.draw_text @dentista.nome.gsub(/[^a-z0-9.:,$ ]/i,'.') , :at => [10,500]
        pdf.font_size = 10
        y = 470
        pdf.draw_text "Data", :at=>[2,y]
        pdf.draw_text "Paciente", :at => [60,y] 
        pdf.draw_text "Procedimento" , :at => [260, y]
        pdf.draw_text "Valor" , :at => [450, y]
        pdf.draw_text "Custo" , :at => [550, y]
        pdf.draw_text "Vl Dentista" , :at => [650, y]

        total_valor = 0
        total_custo = 0
        total_dentista = 0
        y = 450
        if @dentista.ortodontista?
          items = @dentista.busca_producao_de_ortodontia(@data_inicial, @data_final)
        else
          items = @dentista.busca_producao(@data_inicial, @data_final, params[:clinicas])
        end
        items.each do |item|
          pdf.draw_text item.data.to_s_br, :at=>[2,y]
          pdf.draw_text item.paciente.nome.gsub(/[^a-z0-9.:,$ ]/i,'.'), :at => [60,y] 
          pdf.draw_text item.descricao && item.descricao.gsub(/[^a-z0-9.:,$ ]/i,'.') , :at => [260, y]
          
          pdf.bounding_box([450, y+7], :width => 50, :height => 12) do
            pdf.text item.valor.real.to_s, :align => :right
          end

          pdf.bounding_box([550, y+7], :width => 50, :height => 12) do
            pdf.text item.custo.real.to_s, :align => :right
          end
          
          pdf.bounding_box([650, y+7], :width => 50, :height => 12) do
            pdf.text item.valor_dentista.real.to_s, :align => :right 
          end
          y -= 12
          total_valor += item.valor
          total_custo += item.custo
          total_dentista += item.valor_dentista if item.valor_dentista
        end
        pdf.horizontal_line 450, 500, :at => y+7
        pdf.horizontal_line 550, 600, :at => y+7
        pdf.horizontal_line 650, 700, :at => y+7
        pdf.stroke
        y -=7
        pdf.bounding_box([450, y+7], :width => 50, :height => 12) do
          pdf.text total_valor.real.to_s, :align => :right
        end

        pdf.bounding_box([550, y+7], :width => 50, :height => 12) do
          pdf.text total_custo.real.to_s, :align => :right
        end
        
        pdf.bounding_box([650, y+7], :width => 50, :height => 12) do
          pdf.text total_dentista.real.to_s, :align => :right 
        end
        pdf.start_new_page unless dentistas.last == dentista
      end
    end
    send_file File.join(RAILS_ROOT , "impressoes/#{session[:clinica_id]}/producao_detalhada.pdf")

  end
  
  def busca_dentista
    @dentista = Dentista.find(params[:id])  
  end
  
end
