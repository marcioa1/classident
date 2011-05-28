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

debugger
    Prawn::Document.generate("public/relatorios/relatorio.pdf") do |pdf|

      pdf.font "Times-Roman"
      imprime_cabecalho(pdf, titulo)
      pdf.table(items,
            :row_colors =>['FFFFFF', 'DDDDDD'],
            # :header_color => 'AAAAAA',
            :headers => tr[1].split(';'),
            :font_size => 8,
            :align => alinhamento,
            :cell_style => { :padding => 6 }, :width => 550)
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
