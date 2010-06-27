class Tratamento < ActiveRecord::Base
  belongs_to :paciente
  belongs_to :item_tabela
  belongs_to :dentista
  belongs_to :clinica
  belongs_to :orcamento
  
  named_scope :da_clinica, lambda{|clinicas| {:conditions=>["clinica_id in (?)",clinicas]}}
  named_scope :dentistas_entre_datas, 
        lambda {|inicio,fim| {:group=>'dentista_id',:select=>'dentista_id', :conditions=>["data between ? and ? ", inicio,fim]}}
        
  named_scope :do_paciente, lambda{|paciente_id| {:conditions=>["paciente_id = ? and excluido=?", paciente_id,false]}}
  named_scope :do_dentista, lambda{|dentista_id| {:conditions=>["dentista_id = ? ", dentista_id]}}
  named_scope :do_orcamento, lambda{|orcamento_id| {:conditions=>["orcamento_id = ? ", orcamento_id]}}
  named_scope :entre, lambda{|inicio,fim| {:conditions=>["data>=? and data <=?", inicio,fim]}}
  named_scope :feito, :conditions=>["data IS NOT NULL"]
  named_scope :nao_excluido, :conditions=>["excluido = ?",false]
  named_scope :nao_feito, :conditions=>["data IS NULL"]
  named_scope :por_data, :order=>:data
  named_scope :sem_orcamento, :conditions=>["orcamento_id IS NULL"]
  
  validates_presence_of :descricao, :message => "não pode ser vazio."
  validates_presence_of :dentista,  :message => "não pode ser vazio."
  validates_presence_of :dente,     :message => "can't be blank"
  
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
    custo = 0 if custo.nil?
    (valor - custo) * dentista.percentual / 100 
  end
  
  def valor_clinica
    custo = 0 if custo.nil?
    (valor - custo) * (100 - dentista.percentual) / 100 
  end
  
  def nao_pode_alterar?
    created_at < Date.today - 15.days
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
        self.orcamento.save
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
    else
      result = estado
    end
    result
  end
  
  def dentes
    self.dente
  end
  
end
