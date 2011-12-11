Abono.all.each do |ab|
  ab.update_attribute("clinica_id" , ab.paciente.clinica_id)
end