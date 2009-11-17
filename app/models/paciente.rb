class Paciente < ActiveRecord::Base
  belongs_to :tabela
  has_many :tratamentos
  has_many :debitos
  has_many :recebimentos
  
  #validates_uniqueness_of :codigo
  
  def extrato
    result = (recebimentos + debitos).sort { |a,b| a.data<=>b.data }
  end
  
  def saldo
    saldo = 0
    debitos.each() do |debito|
      saldo -= debito.valor
    end
    recebimentos.each() do |recebimento|
      saldo += recebimento.valor
    end
    return saldo
  end
  
  def gera_codigo()
    ultimo = Paciente.last(:order=>"codigo desc", :conditions=>["clinica_id=?", clinica_id])
    if ultimo.nil?
      codigo = 0
    else
      codigo = ultimo.codigo
    end 
    return codigo + 1
  end
  
  
  def nome_e_clinica(clinica)
    if clinica==0
      clinica = Clinica.find(clinica_id)
      return nome + "   (#{clinica.nome})"
    else
      return nome
    end
  end
end
