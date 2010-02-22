class Debito < ActiveRecord::Base
  belongs_to :paciente
  
  def self.cria_debitos_do_orcamento(orcamento_id)
    orcamento = Orcamento.find(orcamento_id)
    (1..orcamento.numero_de_parcelas).each do |par|
      deb = Debito.new
      deb.paciente_id = orcamento.paciente_id
      deb.data = orcamento.vencimento_primeira_parcela + (par - 1).month
      deb.valor = orcamento.valor_da_parcela
      deb.descricao = "ref orçamento " + orcamento.numero.to_s + " parcela " + par.to_s + " / " + orcamento.numero_de_parcelas.to_s
      deb.save
    end
    
  end
  
end
