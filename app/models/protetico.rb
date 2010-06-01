class Protetico < ActiveRecord::Base
  has_many   :tabela_proteticos
  belongs_to :clinica
  has_many   :trabalho_proteticos
  has_many   :pagamentos
  
  named_scope :por_nome, :order=>:nome
  named_scope :ativos, :conditions => ['ativo = ? ', true]
  named_scope :inativos, :conditions => ['ativo = ?', false]
  
end
