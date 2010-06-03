module PacientesHelper
  
  def nome_paciente(paciente)
    "<div class= 'destaque'>Paciente : #{paciente.nome} ( Tabela: #{paciente.tabela.nome})</div>"
  end
  
end
