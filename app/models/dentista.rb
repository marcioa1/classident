class Dentista < ActiveRecord::Base
  has_many :tratamentos
  has_and_belongs_to_many :clinicas
  #named_scope :da_clinica, lambda{|clinica_id| {:conditions=>["clinica_id=?", clinica_id]}}
  named_scope :por_nome, :order=>:nome
  
  def sigla_das_clinicas
    sigla = []
    clinicas.each() do |clinica|
      sigla << clinica.sigla + ", "
    end
    sigla
  end
  
  def busca_producao(inicio,fim,clinicas)
    debugger
    resultado = Tratamento.do_dentista(id).por_data.entre(inicio, fim).da_clinica(clinicas)
  end
  
end
