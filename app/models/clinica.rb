class Clinica < ActiveRecord::Base
  has_many :users
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
  
  named_scope :por_nome, :order=>:nome
  named_scope :administracao, :conditions=>["sigla = 'AD'"]
  named_scope :todas, :conditions=>["sigla <> 'AD'"]
  
end
