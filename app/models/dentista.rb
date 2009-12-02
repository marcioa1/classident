class Dentista < ActiveRecord::Base
  has_many :tratamentos
  has_and_belongs_to_many :clinicas
  #named_scope :da_clinica, lambda{|clinica_id| {:conditions=>["clinica_id=?", clinica_id]}}

  def sigla_das_clinicas
    sigla = []
    clinicas.each() do |clinica|
      sigla << clinica.sigla + ", "
    end
    sigla
  end
  
  def busca_producao
    resultado = Tratamento.all(:conditions=>["dentista_id = ?", id])
  end
  
end
