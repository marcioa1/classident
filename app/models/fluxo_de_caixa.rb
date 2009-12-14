class FluxoDeCaixa < ActiveRecord::Base
  named_scope :atual, :conditions=>[:last]
  named_scope :da_clinica, lambda{|clinica_id| {:conditions=>["clinica_id=?", clinica_id]}}
  
  def voltar_para_a_data(data,clinica_id)
    a_apagar = FluxoDeCaixa.all(:conditions=>["clinica_id=? and data>?", clinica_id, data])
    a_apagar.each() do |reg|
      reg.delete
    end
    return FluxoDeCaixa.da_clinica(clinica_id).last
  end
  
  def avancar_um_dia(clinica_id,data)
    recebimentos = Recebimento.da_clinica(clinica_id).no_dia(data).nao_excluidos
    dinheiro_id = FormasRecebimento.find_by_nome("dinheiro")
    cheque_id = FormasRecebimento.find_by_nome("cheque")
    recebimentos_em_dinheiro = Recebimento.sum(:valor, :conditions=>["formas_recebimento_id = ?", dinheiro_id])
    recebimentos_em_cheque = Recebimento.sum(:valor, :conditions=>["formas_recebimento_id = ?", cheque_id])
    pagamentos = Pagamento.da_clinica(clinica_id).no_dia(data)
    pagamentos_em_dinheiro = 10 
    pagamentos_em_cheque = 10
    #TODO fazer o calculo acima
    saldo_em_cheque = recebimentos_em_cheque - pagamentos_em_cheque
    saldo_em_dinheiro = recebimentos_em_dinheiro - pagamentos_em_dinheiro
    fluxo_atual = FluxoDeCaixa.find_by_data(data - 1.day)
    debugger
    return FluxoDeCaixa.create(:data => fluxo_atual.data + 1.day,
       :saldo_em_cheque => fluxo_atual.saldo_em_cheque + saldo_em_cheque,
       :saldo_em_dinheiro => fluxo_atual.saldo_em_dinheiro + saldo_em_dinheiro)
  end
end
