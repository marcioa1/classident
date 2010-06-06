module PacientesHelper
  
  def nome_paciente(paciente)
    debugger
    result = "<div class= 'destaque'>Paciente : #{paciente.nome} "
    result += " ( Tabela: #{paciente.tabela.nome}) " if paciente.tabela
    result += "</div>"
    result
  end
  
end
