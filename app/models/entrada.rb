class Entrada < ActiveRecord::Base
  acts_as_audited  
  belongs_to :clinica
  
  validates_numericality_of :valor, :message => "is not a number"
  validates_presence_of :observacao, :message => "não pode ser vazio"
  
  named_scope :da_clinica, lambda{|clinica_id| {:conditions=>["clinica_id = ?", clinica_id]}}
  named_scope :do_mes, lambda{|data| {:conditions=>["data between ? and ? ", 
    data.strftime("%Y-%m-01"),data.strftime("%Y-%m-31")], :order=>:data}}
  named_scope :do_dia, lambda{|dia| {:conditions=>["data = ?",dia]}}
  named_scope :entre_datas, lambda{|data_inicial, data_final| {:conditions=>["data between ? and ? ", 
      data_inicial, data_final]}}
  named_scope :entrada, :conditions=>["valor > 0"]
  named_scope :remessa, :conditions=>["valor < 0"]
  named_scope :confirmado, :conditions=>['data_confirmacao_da_entrada IS NOT NULL']
  
  attr_accessor :valor_br
  
  def valor_br
    self.valor.real.to_s
  end
  
  def valor_br=(valor_lido)
    self.valor = valor_lido.gsub('.', '').gsub(',', '.')
  end
  
  def confirmada?
    data_confirmacao_da_entrada.present?  
  end
  
end
