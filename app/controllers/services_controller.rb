class ServicesController < ApplicationController
  
  def events
    p = Paciente.all(:select=>'nome', :limit=>15, :order=>'nome asc')
    # json = p.map!{ |paciente| %{"#{paciente.id}":"#{paciente.nome}"} }.join(',')
    # render :json => "{#{json}}"
    result = []
    p.each do |pac|
      result << pac.nome
    end
    render :json => result.to_json
  end
  
end
