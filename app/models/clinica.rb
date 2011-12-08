class Clinica < ActiveRecord::Base
  acts_as_audited
  has_and_belongs_to_many :users
  has_many :pagamentos
  has_and_belongs_to_many :dentistas
  has_many :recebimentos
  has_many :cheques
  has_many :tratamentos
  has_many :destinacaos
  has_many :proteticos
  has_many :trabalho_proteticos
  has_many :conta_bancarias
  has_many :pacientes
  has_many :tabelas
  
  named_scope :administracao, :conditions=>["sigla = 'ad'"]
  named_scope :da_classident, :conditions=>['id < 8']
  named_scope :por_nome, :order=>:nome
  named_scope :todas, :conditions=>["sigla <> 'ad'"]

 ADMINISTRACAO_ID   = 1 #Clinica.administracao.first.id
 NUMERO_DE_CLINICAS = Clinica.da_classident.count
  
  def ortodontistas
    result = []
    self.dentistas.each do |dentista|  
      result << dentista if dentista.ortodontista
    end
    result.sort! {|a,b| a.nome <=> b.nome}
  end  
  
  def self.busca_clinica(id)
    @clinica = Rails.cache.read("clinica_#{id}")
    if !@clinica
      @clinica = Clinica.find(id)
      Rails.cache.write("clinica_#{id}", @clinica, :expires_in => 12.hours) 
    end
    @clinica
  end
  

end
