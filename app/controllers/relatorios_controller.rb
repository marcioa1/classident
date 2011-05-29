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
      repeat :all do
        draw_text titulo, :at => bounds.top_left
        move_down 5
      end
     
      self.font_size = 10
      header = tr[1].split(';')
      data = items.flatten
      table([header] + items , :header => true) do
        row(0).style(:font_style => :bold, :background_color => 'cccccc')
      end
    end
    
    head :ok
  end
  
  protected
  
  def imprime_cabecalho(pdf, titulo)
    pdf.image "public/images/logo-print.jpg", :align => :left
    pdf.text "#{Time.current.to_s_br}", :align => :right, :size=>8
    pdf.move_down 20
    pdf.text titulo, :align => :center, :size => 14
    pdf.move_down 20
  end
end
