class Dentista < ActiveRecord::Base
  acts_as_audited
  has_many :tratamentos
  has_and_belongs_to_many :clinicas
  has_many :trabalho_proteticos
  has_many :pagamentos
  # has_many :pacientes_de_ortodontia, :class_name=>"Paciente", :foreign_key=>"ortodontista_id"
  
  validates_presence_of :nome, :cro, :percentual, :message => "não pode ser vazio ( em branco )."
  validates_numericality_of :percentual
  
  named_scope :ativos, :conditions=>["ativo=?", true]
  named_scope :da_classident, :conditions => ["clinica_id < 8"]
  named_scope :inativos, :conditions=>["ativo=?", false]
  named_scope :por_nome, :order=>:nome
  named_scope :que_iniciam_com, lambda{|iniciais| {:conditions=>['nome like ?', iniciais + '%']}}
  
  def producao_mensal(ano,mes)
    inicio = Date.new(ano.to_i,mes.to_i,1)
    fim = inicio + 1.month - 1.day
    valor = Tratamento.sum(:valor,:conditions=>['dentista_id = ? and data between ? and ? and not excluido ', self.id, inicio, fim])
    return valor #self.percentual.to_s + "/" + valor.to_s + "/" + custo.to_s + "/" + do_dentista.to_s  + "/" + da_clinica.to_s
  end
  
  def producao_entre_datas(inicio,fim)
    custo = Tratamento.sum(:custo,:conditions=>['dentista_id = ? and data between ? and ? and not excluido ', self.id, inicio, fim]).to_f
    valor = Tratamento.sum(:valor,:conditions=>['dentista_id = ? and data between ? and ? and not excluido ', self.id, inicio, fim]).to_f
    #FIXME
    custo           = 0 if custo.nil?
    valor           = 0 if valor.nil?
    self.percentual = 0 if self.percentual.nil?
    do_dentista     = (valor - custo ) * self.percentual / 100
    da_clinica      = valor - custo - do_dentista
    return self.percentual.to_s + "/" + valor.to_s + "/" + custo.to_s + "/" + do_dentista.to_s  + "/" + da_clinica.to_s
  end
  
  def sigla_das_clinicas
    sigla = []
    clinicas.each() do |clinica|
      sigla << clinica.sigla + ", "
    end
    sigla
  end
  
  def busca_producao(inicio,fim,clinicas)
    resultado = Tratamento.do_dentista(id).por_data.entre(inicio, fim).da_clinica(clinicas)
  end
  
  def busca_producao_de_ortodontia(inicio,fim)
     resultado = Recebimento.all(:conditions =>["(data between ? and ?) and paciente_id in (?)",inicio,fim,self.pacientes_de_ortodontia ])
  end

  def self.busca_dentistas(clinica_id)
    # key       = 'dentistas_' + clinica_id.to_s
    # dentistas = Rails.cache.read(key)
    # if !dentistas
      clinica   = Clinica.find(clinica_id)
      dentistas = clinica.dentistas.ativos.collect{|obj| [obj.nome,obj.id]}.sort
    #   Rails.cache.write(key, dentistas, :expires_in => 2.hours) 
    # end
    dentistas
  end
  
  def pacientes_de_ortodontia
    # Paciente.all(:select=>"id, nome", :conditions => ["ortodontista_id = ?", self.id]).map(&:id) 
    Paciente.all(:conditions => ["clinica_id < 8 and ortodontista_id = ?", self.id],
                 :order => :nome,
                 :select => 'nome, id, mensalidade_de_ortodontia,data_da_suspensao_da_cobranca_de_orto,motivo_suspensao_cobranca_orto')
  end

end
