class Orcamento < ActiveRecord::Base
  acts_as_audited
  belongs_to :paciente
  belongs_to :dentista
  belongs_to :paciente
  has_many :tratamentos
  
  named_scope :acima_de, lambda{|valor| {:conditions=>['valor_com_desconto >=?',valor]}}
  named_scope :da_clinica, lambda{|clinica_id| {:conditions=>['clinica_id = ? ', clinica_id]}}
  named_scope :do_dentista, lambda{|dentista_id| {:conditions=>['dentista_id = ?', dentista_id]}}
  named_scope :do_paciente, lambda{|paciente_id| {:conditions=>['paciente_id = ?', paciente_id]}}
  named_scope :em_aberto, :conditions=>['data_de_inicio IS NULL']
  named_scope :entre_datas, lambda{|data_inicial, data_final| {:conditions=>['data between ? and ?', data_inicial, data_final]}}
  named_scope :iniciado, :conditions=>['data_de_inicio IS NOT NULL']
  named_scope :por_dentista, :order=>:dentista_id
  named_scope :ultimo_codigo, :order=>["numero DESC"]

  validates_numericality_of :valor, :message=>'Valor deve ser numérico .'
  validates_numericality_of :valor_da_parcela, :message=>'Valor deve ser numérico .'
  validates_presence_of :data, :valor_da_parcela
  
  attr_accessor :data_pt, :valor_pt, :valor_com_desconto_pt, :valor_da_parcela_pt
  
  def data_pt
    data_pt = self.data.to_s_br if Date.valid?(self.data)
  end
  def data_pt=(new_date)
    self.data = new_date.to_date if Date.valid?(new_date)
  end
  
  def valor_pt
    valor_pt = self.valor.real if self.valor
  end
  def valor_pt=(new_value)
    self.valor = new_value.gsub('.', '').gsub(',', '.')
  end
  
  def valor_com_desconto_pt
    valor_com_desconto_pt = self.valor_com_desconto.real if self.valor_com_desconto
  end
  def valor_com_desconto_pt=(new_value)
    self.valor_com_desconto = new_value.gsub('.', '').gsub(',', '.').to_f
  end

  def valor_da_parcela_pt
    valor_da_parcela_pt = self.valor_da_parcela.real if self.valor_da_parcela
  end
  def valor_da_parcela_pt=(new_value)
    self.valor_da_parcela = new_value.gsub('.', '').gsub(',', '.').to_f
  end
  
  def estado
    nao_feito = Tratamento.first(:conditions=>['orcamento_id = ? and data IS NULL', self.id])
    feito     = Tratamento.first(:conditions=>['orcamento_id = ? and data IS NOT NULL', self.id])
    return 'aberto' if em_aberto?
    return 'iniciado'  if iniciado?
    return 'terminado' if nao_feito.nil?
    return 'aceito'
  end
  
  def em_aberto?
    data_de_inicio.nil?
  end
  
  def aprovado?
    !em_aberto?
  end
  
  def iniciado?
    result = Tratamento.do_paciente(self.paciente_id).nao_excluido.feito.do_orcamento(self.id)
    result.present?
  end
  
  def valor_final
    
  end
  
  def self.proximo_numero(paciente_id)
    maior_codigo = Orcamento.do_paciente(paciente_id).ultimo_codigo.last
    if maior_codigo.nil?
      return 1
    else
      return maior_codigo.numero + 1
    end
  end

  def self.monta_tabela_de_parcelas(numero_de_parcelas,data,valor)
    result = "<div id='parcelas'><table class='tabela'><tr><th>N. parcela</th><th>Data</th><th>Valor</th></tr>"
    (1..numero_de_parcelas).each do |parcela|
      result += "<tr><td align='center'>#{parcela}</td><td>#{data.to_s_br}</td><td>#{valor}</td></tr>"
      data   += 1.month
    end
    result
  end
  
  def explicacoes
    result = {}
    self.tratamentos.each do |trat|
      if trat.item_tabela.present?
        if trat.item_tabela.descricao_conduta
          result = result.merge({trat.item_tabela.codigo =>
                        trat.item_tabela.descricao_conduta.descricao})
        end
      end
    end
    result
  end
  
  def a_vista?
    self.forma_de_pagamento == 'a vista'
  end
  
  def recalcula_valor
    if em_aberto?
      total = 0
      self.tratamentos.each do |trat|
        total += trat.valor if !trat.excluido?
      end
      self.valor = total
    end
    if self.desconto && self.desconto != 0
      self.valor_com_desconto = self.valor * ( 1 - (self.desconto / 100)) 
    else
      self.valor_com_desconto = self.valor
    end
  end
  
end
