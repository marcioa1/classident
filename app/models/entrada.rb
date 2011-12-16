class Entrada < ActiveRecord::Base
  acts_as_audited  
  belongs_to :clinica
  belongs_to :clinica_destino, :class_name => 'Clinica', :foreign_key => :clinica_destino
  
  validates_numericality_of :valor, :message => "is not a number"
  # validates_presence_of :observacao, :message => "não pode ser vazio"
  
  named_scope :confirmado, :conditions=>['data_confirmacao_da_entrada IS NOT NULL']
  named_scope :da_clinica, lambda{|clinica_id| {:conditions=>["clinica_id = ?", clinica_id]}}
  named_scope :para_clinica, lambda{|clinica_destino| {:conditions=>["clinica_destino = ?", clinica_destino]}}
  named_scope :do_mes, lambda{|data| {:conditions=>["data between ? and ? ", 
    data.strftime("%Y-%m-01"),data.strftime("%Y-%m-31")], :order=>:data}}
  named_scope :do_dia, lambda{|dia| {:conditions=>["data = ?",dia]}}
  named_scope :entre_datas, lambda{|data_inicial, data_final| {:conditions=>["data between ? and ? ", 
      data_inicial, data_final]}}
  named_scope :entrada_na_clinica, lambda{|clinica_id| {:conditions=>["clinica_destino = ? and clinica_destino  != ?",clinica_id, Clinica::ADMINISTRACAO_ID]}}
  named_scope :entrada_na_administracao,  :conditions=>["clinica_destino = ?", Clinica::ADMINISTRACAO_ID]
  named_scope :nao_e_resolucao_de_cheque, :conditions=>['resolucao_de_cheque IS FALSE']
  named_scope :remessa_da_administracao , :conditions =>["clinica_id=? and clinica_destino != ?",Clinica::ADMINISTRACAO_ID,Clinica::ADMINISTRACAO_ID ]
  
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
  
  def remessa?(clinica_id)
    Clinica.find(clinica_id).administracao? ?  self.clinica_id == 1 && self.clinica_destino.id != 1 : self.clinica_id > 1 
  end


  def na_quinzena?
    primeira = Date.new(Date.today.year,Date.today.month,1)
    segunda  = Date.new(Date.today.year,Date.today.month,16)
    if Date.today >= segunda
      self.data < segunda ? false : true
    else
      self.data < primeira ? false : true
    end
  end
  
  def pode_excluir?
    self.na_quinzena?
  end
  
  def nome_clinica_destino
    
  end
  
  def self.remessas(data,clinica)
    remessas = Entrada.all(:conditions=> ["data = ? and clinica_destino = ? and clinica_id = ?", data, Clinica::ADMINISTRACAO_ID,clinica])
    remessas || []
  end
  
end
