class Dentista < ActiveRecord::Base
  has_many :tratamentos
  has_and_belongs_to_many :clinicas
  has_many :trabalho_proteticos
  has_many :pagamentos
  
  #named_scope :da_clinica, lambda{|clinica_id| {:conditions=>["clinica_id=?", clinica_id]}}
  named_scope :por_nome, :order=>:nome
  named_scope :ativos, :conditions=>["ativo=?", true]
  named_scope :inativos, :conditions=>["ativo=?", false]
  named_scope :ortodontistas, :conditions=>["ortodontista=?", true]
  named_scope :que_iniciam_com, lambda{|iniciais| {:conditions=>['nome like ?', iniciais + '%']}}
  
  def producao_mensal(ano,mes)
    inicio = Date.new(ano.to_i,mes.to_i,1)
    fim = inicio + 1.month - 1.day
    valor = Tratamento.sum(:valor,:conditions=>['dentista_id = ? and data between ? and ? and not excluido ', self.id, inicio, fim])
    return valor #self.percentual.to_s + "/" + valor.to_s + "/" + custo.to_s + "/" + do_dentista.to_s  + "/" + da_clinica.to_s
  end
  
  def producao_entre_datas(inicio,fim)
    custo = Tratamento.sum(:custo,:conditions=>['dentista_id = ? and data between ? and ? and not excluido ', self.id, inicio, fim])
    valor = Tratamento.sum(:valor,:conditions=>['dentista_id = ? and data between ? and ? and not excluido ', self.id, inicio, fim])
    do_dentista = (valor - custo ) * percentual / 100
    da_clinica = valor - custo - do_dentista
    return self.percentual.to_s + "/" + valor.to_s + "/" + custo.to_s + "/" + do_dentista.to_s  + "/" + da_clinica.to_s
 
  end
  
  def sigla_das_clinicas
    sigla = []
    clinicas.each() do |clinica|
      sigla << clinica.sigla + ", "
    end
    sigla
  end
  
  def busca_producao(inicio,fim,clinicas)
    resultado = Tratamento.do_dentista(id).por_data.entre(inicio, fim).da_clinica(clinicas)
  end
  
end
