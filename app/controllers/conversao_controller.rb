class ConversaoController < ApplicationController

def index
  c = Converte.new
 # c.converte_cadastro 
  c.mala_direta
#  c.converte_debito
#  c.converte_formas_recebimento
 # c.converte_recebimento
end

end
