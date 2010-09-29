module PacientesHelper
  
  def nome_paciente(paciente)
     "<p class='identifica_paciente'>Ficha do paciente (#{paciente.sequencial}) : <b><a href='/pacientes/#{paciente.id}/abre'>#{paciente.nome}</a></b> &nbsp;&nbsp;&nbsp;&nbsp; ( Tel.: #{paciente.telefones} )</p> "     if paciente
  end
  
end
