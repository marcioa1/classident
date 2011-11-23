class Alteracoe < ActiveRecord::Base
  
  def self.retira_permissao_de_alteracao(tabela,id_registro)
    reg = Alteracoe.find_by_tabela_and_id_liberado(tabela, id_registro)
    if reg
      reg.data_correcao = Time.now
      reg.save
    end
  end
  
end
