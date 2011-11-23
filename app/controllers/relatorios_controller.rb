class RelatoriosController < ApplicationController
  
  before_filter :verify_existence_of_directory
  
  def imprime
    require "prawn/layout"
    require "prawn/core"
    
    dados            = params[:dados]
    clinica_atual    = Clinica.find(params[:clinica_id])
    nome_da_clinica  = clinica_atual.nome
    sigla_da_clinica = clinica_atual.sigla
    params[:orientation] = 'landscape' if params[:orientation].nil?
    if ( landscape = params[:orientation].downcase == 'landscape')
      devy = 540 #520
    else
      devy = 740 #690
    end
    items     = []
    tr        = params[:tabela].split(">")
    cabecalho = tr[0].split(';')
    titulo    = cabecalho[0] 
    tr.each_with_index do |td,index|
      if index > 2
        linha = td.split(';').to_a
        items << linha
      end
    end
    alinhamento = Hash.new
    tr[2].split(';').each_with_index do |elem, index|
      alinhamento.merge!({index => elem.to_sym})
    end

    Prawn::Document.generate(File.join(Rails.root,"/impressoes/#{session[:clinica_id]}/relatorio.pdf"), :page_layout => params[:orientation].to_sym) do 
    repeat :all do
      text "#{Time.current.to_s_br} - #{sigla_da_clinica}", :align => :right, :size=>8

      # image "public/images/logo-print.jpg", :align => :left, :vposition => -20

      if landscape == 'landscape'
        bounding_box [50, devy], :width  => bounds.width do
          font "Helvetica"
          text titulo, :align => :center, :size => 11, :vposition => -20
        end
      else
        bounding_box [2, devy], :width  => bounds.width do
          font "Helvetica"
          text titulo, :align => :left, :size => 11, :vposition => -20
        end
      end
    end
     
      self.font_size = 9
      header = tr[1].split(';')
      data = items.flatten
      items.each do |it|
        it.each_with_index do |st,index|
          it[index] = st.gsub(/[^a-z0-9.:,$áéíóúãõ˜eç\/\- ]/i,'.')
        end
      end
      bounding_box [2, devy - 50], :width  => bounds.width do
        table([header] + items , :header => true) do
            # style(row(0), :background_color => 'ff00ff')
          row(0).style(:font_style => :bold, :background_color => 'cccccc')
          tr[2].split(';').each_with_index do |al,index|
            column(index).style(:align=>al.to_sym)
          end
        end
      end
    end

    send_file RAILS_ROOT + "/impressoes/#{session[:clinica_id]}/relatorio.pdf"

     # head :ok
  end
  
  
  # def verify_existence_of_directory
  #   directory_name = Dir::pwd + "/impressoes/#{session[:clinica_id]}"
  #   if FileTest::directory?(directory_name)
  #     return
  #   else
  #     Dir::mkdir(directory_name)
  #   end
  # end

  # protected
  
  def imprime_cabecalho(pdf, titulo)
    pdf.image "public/images/logo-print.jpg", :align => :left
    pdf.text "#{Time.current.to_s_br}", :align => :right, :size=>8
    pdf.move_down 20
    pdf.text titulo, :align => :center, :size => 14
    pdf.move_down 20
  end
end
