class Tratamento < ActiveRecord::Base
  acts_as_audited
  belongs_to :paciente
  belongs_to :item_tabela
  belongs_to :dentista
  belongs_to :clinica
  belongs_to :orcamento
  has_many   :trabalho_proteticos
  has_one    :debito
  
  named_scope :da_clinica, lambda{|clinicas| {:conditions=>["clinica_id in (?)",clinicas]}}
  named_scope :dentistas_entre_datas, 
        lambda {|inicio,fim| {:group=>'dentista_id',:select=>'dentista_id', :conditions=>["data between ? and ? ", inicio,fim]}}
        
  named_scope :do_paciente, lambda{|paciente_id| {:conditions=>["paciente_id = ?", paciente_id]}}
  named_scope :do_dentista, lambda{|dentista_id| {:conditions=>["dentista_id = ? ", dentista_id]}}
  named_scope :do_orcamento, lambda{|orcamento_id| {:conditions=>["orcamento_id = ? ", orcamento_id]}}
  named_scope :entre, lambda{|inicio,fim| {:conditions=>["data>=? and data <=?", inicio,fim]}}
  named_scope :feito, :conditions=>["data IS NOT NULL"]
  named_scope :nao_excluido, :conditions=>["excluido = ?",false]
  named_scope :nao_feito, :conditions=>["data IS NULL"]
  named_scope :pacientes_em_tratamento, :conditions => ['data IS NULL'], :group=>'paciente_id', :select=> 'paciente_id'
  named_scope :por_data, :order=>:data
  named_scope :sem_orcamento, :conditions=>["orcamento_id IS NULL"]
  named_scope :ultima_data, lambda{|data| {:conditions=>['data <= ?', data ], :limit=>1, :order=>'data DESC'}}
  
  validates_presence_of :descricao, :message => "não pode ser vazio."
  validates_presence_of :dentista,  :message => "não pode ser vazio."
  validate :data_nao_pode_ser_futura
  validates_presence_of :custo , :if => :item_de_protetico?, 
          :message => 'Este item tem obrigaoriamente que ter um custo associado.'
  validates_numericality_of :custo, :greater_than => 0 ,  :if => :item_de_protetico?, 
          :message => ' : este item tem que obrigatoriamente ter um custo associado.'
  
  attr_accessor :data_termino_br, :valor_pt, :custo_pt
  
  def valor_pt
    self.valor.real rescue "0,00"
  end
  def valor_pt=(new_value)
    self.valor = new_value.gsub(".","").gsub(",",".").to_f rescue 0.0
  end
  
  def custo_pt
    self.custo.real rescue "0,00"
  end
  def custo_pt=(new_value)
    self.custo = new_value.gsub(".","").gsub(",",".").to_f rescue 0.0
  end
  
  
  def data_termino_br
    self.data ? self.data.to_s_br : nil 
  end
  
  def data_termino_br=(value)
    if Date.valid?(value)
      self.data = value.to_date
    else
      self.data = nil
    end
  end
  
  def data_nao_pode_ser_futura
    if self.data_termino_br && self.data_termino_br.to_date > Date.today
      errors.add(:data_de_termino, " não pode ser futura")
    end
  end
  def self.valor_a_fazer(paciente_id)
    Tratamento.sum(:valor, :conditions=>["paciente_id = ? and data IS NULL and excluido  = ? and orcamento_id IS NULL", paciente_id, false])
  end
  
  def self.ids_orcamento(paciente_id)
    Tratamento.all(:select=>:id, :conditions=>["paciente_id = ? and data IS NULL and excluido  = ? and orcamento_id IS NULL", paciente_id, false]).map{|obj| obj.id}
  end
  
  
  def self.associa_ao_orcamento(ids, orcamento_id)
    ids.split(',').each do |id|  
      t = Tratamento.find(id)
      t.orcamento_id = orcamento_id
      t.save
    end
  end
  
  def valor_dentista
    self.custo = 0 if self.custo.nil?
    (self.valor_com_desconto - self.custo) * dentista.percentual / 100 
  end
  
  def valor_clinica
    self.custo = 0 if self.custo.nil?
    (self.valor_com_desconto - self.custo) * (100 - dentista.percentual) / 100 
  end
  
  def pode_excluir?
    pode_alterar? #&& self.data.nil?
  end
  
  def pode_alterar?
    na_quinzena?
  end
  
  def na_quinzena?
    if self.data
      primeira = Date.new(Date.today.year,Date.today.month,1)
      segunda  = Date.new(Date.today.year,Date.today.month,16)
      return false if self.data < primeira
      return false if self.data < segunda && Date.today >= segunda
      return true if self.data < segunda && Date.today < segunda
      return true if self.data >= segunda && Date.today >= segunda
    else
      return true
    end
  end
  
  def item_de_protetico?
    self.item_tabela && self.item_tabela.tem_custo_de_protetico? && self.data.present?
  end
  
  def pode_finalizar?
    return true if self.item_tabela.nil?
    self.item_tabela && (!self.item_tabela.tem_custo_de_protetico? || self.custo > 0)
  end
  
  def finalizar(user, clinica_id)
    if self.valor > 0
      debito               = Debito.new
      debito.paciente_id   = self.paciente_id
      debito.tratamento_id = self.id
      debito.descricao     = self.descricao + " (dente :" + self.dente + ")"
      debito.valor         = self.valor_com_desconto
      debito.data          = self.data
      debito.clinica_id    = clinica_id 
      debito.save
    else
      if self.orcamento && self.orcamento.em_aberto?
        self.orcamento.data_de_inicio = self.data
      end
    end
    if paciente.em_alta?
      alta                 = paciente.altas.last(:order=>:id)
      alta.data_termino    = Time.now
      alta.user_termino_id = user
      alta.save
    end
    if self.item_tabela && self.item_tabela.dias_de_retorno > 0
      alta = Alta.new()
      alta.paciente_id  = self.paciente_id
      alta.clinica_id   = self.paciente.clinica_id
      alta.observacao   = "Término proc #{self.item_tabela.descricao} em #{self.data}"
      alta.user_id      = user
      alta.data_inicio  = Time.current
      alta.data_termino = alta.data_inicio + self.item_tabela.dias_de_retorno.days
      alta.save!
    end
  end
  
  def faces
    if estado == 'nenhum'
      result = ''
      result += "M" if mesial
      result += "D" if distal
      result += "O" if oclusal
      result += 'L' if lingual
      result += 'V' if vestibular
      result += 'P' if palatina
    else
      result = estado
    end
    result
  end
  
  def dentes
    self.dente
  end
  
  def resumo_protetico
    result = ''
    self.trabalho_proteticos.each do |trab|
      if trab.devolvido?
        result +=  trab.tabela_protetico.descricao + " (#{trab.protetico.nome}), "
      else
        result += "<i>" + trab.tabela_protetico.descricao + " (#{trab.protetico.nome})</i>, "
      end
    end
    result
  end
  
    
  def adiciona_custo(valor)
    self.custo += valor
    self.save
  end
  
  def desconto
    if self.orcamento
      self.orcamento.desconto
    else
      0
    end
  end
  
  def valor_com_desconto
    if self.desconto > 0
      self.valor * (100-self.desconto) / 100
    else
      self.valor
    end
  end
  
  def liberado_para_alteracao?
    reg = Alteracoe.find_by_tabela_and_id_liberado(self.class.table_name, self.id)
    reg && reg.data_correcao.nil?
  end

end
