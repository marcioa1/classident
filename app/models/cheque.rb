class Cheque < ActiveRecord::Base
  belongs_to :recebimento
  belongs_to :banco
  named_scope :por_bom_para, :order=>:bom_para
  named_scope :da_clinica, lambda{|clinica_id| {:conditions=>["clinica_id=?",clinica_id]}}
  named_scope :entre_datas, lambda{|data_inicial, data_final| 
      {:conditions=>["bom_para between ? and ?", data_inicial, data_final]}}

  named_scope :disponiveis, :conditions=>["data_segunda_devolucao IS NULL and 
        data_spc IS NULL and data_solucao IS NULL and data_arquivo_morto IS NULL
        and data_entrega_administracao IS NULL"]
  
  def status
    return "arquivo morto" unless !arquivo_morto?
    return "SPC" unless !spc?
    return "solucionado" unless !solucionado?
    return "devolvido duas vezes em " + data_segunda_devolucao.to_s_br unless !devolvido_duas_vezes? 
    return "reapresentado em " + data_reapresentacao.to_s_br unless !reapresentado?
    return  "devolvido uma vez em " + data_primeira_devolucao.to_s_br unless !devolvido_uma_vez?
    return "normal" unless !sem_devolucao? 
  end
  
  def sem_devolucao?
    data_primeira_devolucao.nil?
  end
  
  def devolvido_uma_vez?
    !data_primeira_devolucao.nil?  
  end
  
  def reapresentado?
    !data_reapresentacao.nil?
  end
  
  def devolvido_duas_vezes?
    !data_segunda_devolucao.nil?
  end
  
  def solucionado?
    !data_solucao.nil?
  end
  
  def spc?
    !data_spc.nil?
  end
  
  def arquivo_morto?
    !data_arquivo_morto.nil?
  end
  
  def entregue_na_administracao?
    !data_entrega_administracao.nil?
  end
  
  def disponivel?
    return false if devolvido_duas_vezes?
    return false if spc?
    return false if arquivo_morto?
    return false if solucionado?
    true
  end
  
end
#TODO Discutir qual cheque é disponivel