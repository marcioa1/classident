RGhost::Document.new :paper => :A4 do |doc|
  doc.show "Tabela de procedimentos"
  doc.next_row
  doc.grid :data => @tabela.item_tabelas do |g|
    g.column :codigo, :title => "Codigo", :align => :center
    g.column :descricao, :title => "Descricao"
#    g.column :created_at, :title => "Client since", :format => lambda{|d| d.strftime('%d/%m/%Y')}
  end
 end