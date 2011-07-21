class RelatoriosController < ApplicationController
  
  def imprime
    require "prawn/layout"
    require "prawn/core"
    params[:orientation] = 'landscape' if params[:orientation].nil?
    if ( landscape = params[:orientation].downcase == 'landscape')
      devy = 520
    else
      devy = 690
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

    Prawn::Document.generate(File.join(Rails.root,"public/relatorios/#{session[:clinica_id]}/relatorio.pdf"), :page_layout => params[:orientation].to_sym) do 
    repeat :all do
      image "public/images/logo-print.jpg", :align => :left, :vposition => -20
      if landscape == 'landscape'
        bounding_box [50, devy], :width  => bounds.width do
          font "Helvetica"
          text titulo, :align => :center, :size => 12, :vposition => -20
        end
      else
        bounding_box [10, devy], :width  => bounds.width do
          font "Helvetica"
          text titulo, :align => :center, :size => 12, :vposition => -20
        end
      end
    end
     
      self.font_size = 9
      header = tr[1].split(';')
      data = items.flatten
      bounding_box [2, devy - 20], :width  => bounds.width do
        table([header] + items , :header => true) do
            # style(row(0), :background_color => 'ff00ff')
          row(0).style(:font_style => :bold, :background_color => 'cccccc')
          tr[2].split(';').each_with_index do |al,index|
            column(index).style(:align=>al.to_sym)
          end
        end
      end
    end
    
    head :ok
  end
  
  # protected
  
  def imprime_cabecalho(pdf, titulo)
    pdf.image "public/images/logo-print.jpg", :align => :left
    pdf.text "#{Time.current.to_s_br}", :align => :right, :size=>8
    pdf.move_down 20
    pdf.text titulo, :align => :center, :size => 14
    pdf.move_down 20
  end
end
