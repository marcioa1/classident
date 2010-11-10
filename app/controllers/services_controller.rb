class ServicesController < ApplicationController
  
  def events
    p = Paciente.all(:select=>'nome, id', :limit=>3)
    render :json => p.to_json
  end
  
end
