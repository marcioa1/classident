class RelatoriosController < ApplicationController
  
  def imprime
    require "prawn/layout"
    require "prawn/core"
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

    Prawn::Document.generate("public/relatorios/#{session[:clinica_id]}/relatorio.pdf", :page_layout => :landscape) do 
      # repeat :all do
      #   image "public/images/logo-print.jpg", :align => :left
      #   draw_text titulo, :at => bounds.top_left
      #   # bounds.height = 100
      #   move_down 5
      # end
    repeat :all do
      image "public/images/logo-print.jpg", :align => :left, :vposition => -20
      bounding_box [50, 550], :width  => bounds.width do
        font "Helvetica"
        text titulo, :align => :center, :size => 12, :vposition => -20
          # stroke_horizontal_rule
          # move_down 25
      end
    end
     
      self.font_size = 9
      header = tr[1].split(';')
      data = items.flatten
      bounding_box [2, 500], :width  => bounds.width do
        table([header] + items , :header => true) do
            # style(row(0), :background_color => 'ff00ff')
          row(0).style(:font_style => :bold, :background_color => 'cccccc')
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
