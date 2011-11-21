class Alteracoe < ActiveRecord::Base
  
  def self.retira_permissao_de_alteracao(tabela,id_registro)
    reg = Alteracoe.find_by_tabela_and_id_liberado(self.class.table_name, self.id)
    if reg
      reg.data_correcao = Time.now
      reg.save
    end
  end
  
end
