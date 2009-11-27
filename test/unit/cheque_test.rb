require 'test_helper'

class ChequeTest < ActiveSupport::TestCase
  
  def test_entregue_na_adminitracao?
    adm = cheques(:adm)
    dispo = cheques(:disponivel)
    assert adm.entregue_na_administracao?
    assert !dispo.entregue_na_administracao?
  end
  
  def test_sem_devolucao?
    cheque = cheques(:normal)
    assert cheque.sem_devolucao?
  end

  def test_devolvido_uma_vez?
    cheque = cheques(:uma_devolucao)
    assert cheque.devolvido_uma_vez?
  end
  
  def test_devolvido_duas_vezes?
    cheque = cheques(:duas_devolucoes)
    assert cheque.devolvido_duas_vezes?
  end
  
  def test_cheque_solucionado?
    cheque= cheques(:solucionado)
    assert cheque.solucionado?
  end
  
  def test_spc?
    cheque = cheques(:spc)
    assert cheque.spc?
  end
  
  def test_arquivo_morto?
    cheque = cheques(:arquivo_morto)
    assert cheque.arquivo_morto?
  end

end
