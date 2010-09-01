# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def google_pie_chart(data, options = {})
     options[:width] ||= 250
     options[:height] ||= 100
     options[:colors] = %w(0DB2AC B10000 FC8D4D FC694D FABA32 704948 968144 C08FBC ADD97E)
     dt = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-."
     options[:divisor] ||= 1

     while (data.map { |k,v| v }.max / options[:divisor] >= 4096) do
       options[:divisor] *= 10
     end

     opts = {
       :cht => "p3",
       :chd => "e:#{data.map{|k,v|v=v/options[:divisor];dt[v/64..v/64]+dt[v%64..v%64]}}",
       :chl => "#{data.map { |k,v| CGI::escape(k + " (#{v} %)")}.join('|')}",
       :chs => "#{options[:width]}x#{options[:height]}",
       :chco => options[:colors].slice(0, data.length).join(',')
     }

     image_tag("http://chart.apis.google.com/chart?#{opts.map{|k,v|"#{k}=#{v}"}.join('&')}")
   rescue
   end

   def line_graph(data)
     image_tag("http://chart.apis.google.com/chart?chs=200x125&amp;chxt=y&cht=lc&chtt=Correct (%)&chco=0077CC&amp;chd=t:"+ data)
   end

   # def alternate_row_class(cycle_name = :outer)
   #    { :class => cycle(:odd, :even, :name => cycle_name) }
   #  end
   
   # def identifica_paciente(paciente)
   #     return "<p class='identifica_paciente'>Ficha do paciente (#{paciente.sequencial}) : <b>#{paciente.nome}</b> &nbsp;&nbsp;&nbsp;&nbsp; ( Tel.: #{paciente.telefones} )</p> "
   #   end
  
end
