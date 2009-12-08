class Converte

def le_cadastro
  i = 0
  f = File.open("teste.txt", "r")
  while line = f.gets
    registro = line.split(";")
    puts registro[0]
    i += 1
   # p = Paciente.new
  ##  p.nome = registro[0]
  #  p.id = registro[1].to_i
  #  p.tabela_id = registro[2].to_i
  end
end



end

begin
  c = Converte.new
  c.le_cadastro
end