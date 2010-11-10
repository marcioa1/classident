class ServicesController < ApplicationController
  
  def events
    p = Paciente.all(:select=>'nome, id', :limit=>2)
    json = p.map!{ |paciente| %{"#{paciente.id}":"#{paciente.nome}"} }.join(',')
    render :json => "{#{json}}"
  end
  
end
