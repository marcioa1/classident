class Tratamento < ActiveRecord::Base
  acts_as_audited
  belongs_to :paciente
  belongs_to :item_tabela
  belongs_to :dentista
  belongs_to :clinica
  belongs_to :orcamento
  has_many   :trabalho_proteticos
  
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
  validates_presence_of :dente,     :message => "can't be blank"
  
  attr_accessor :data_termino_br
  
  def data_termino_br
    self.data ? self.data.to_s_br : '' 
  end
  
  def data_termino_br=(value)
    if Date.valid?(value)
      self.data = value.to_date
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
    debugger
    (self.valor - self.custo) * dentista.percentual / 100 
  end
  
  def valor_clinica
    self.custo = 0 if self.custo.nil?
    (self.valor - self.custo) * (100 - dentista.percentual) / 100 
  end
  
  def nao_pode_alterar?
    created_at < Date.today - 15.days
  end
  
  def na_quinzena?
    if self.data
      return false if self.data < primeira
      primeira = Date.new(Date.today.year,Date.today.month,1)
      segunda  = Date.new(Date.today.year,Date.today.month,16)
      return false if self.data < segunda && Date.today >= segunda
      return true if self.data < segunda && Date.today < segunda
      return true if self.data >= segunda && Date.today >= segunda
    else
      return true
    end
  end
  
  def finalizar_procedimento(user)
    if self.orcamento.nil?
      debito = Debito.new
      debito.paciente_id = paciente_id
      debito.tratamento_id = id
      debito.descricao = item_tabela.descricao
      debito.valor = valor
      debito.data = data
      debito.save
    else
      if self.orcamento.em_aberto?
        self.orcamento.data_de_inicio = self.data
        Debito.cria_debitos_do_orcamento(@orcamento.id) unless @orcamento.data_de_inicio.nil?
      end
    end
    if paciente.em_alta?
      alta = paciente.altas.last(:order=>:id)
      alta.data_termino = Time.now
      alta.user_termino_id = user
      alta.save
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
    else
      result = estado
    end
    result
  end
  
  def dentes
    self.dente
  end
  
end
