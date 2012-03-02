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
  
  def producao_entre_datas(inicio,fim,clinica_id)
    valor = 0
    custo = 0
    do_dentista = 0
    if self.ortodontista?
      producao_de_ortodontista = self.busca_producao_de_ortodontia(inicio,fim)
      producao_de_ortodontista.each do |prod|
        valor += prod.valor.to_f
        do_dentista += prod.valor.to_f * prod.percentual_dentista / 100
      end
    else
      custo  = Tratamento.sum(:custo,:conditions=>['dentista_id = ? and data between ? and ? and not excluido and clinica_id = ? ', self.id, inicio, fim, clinica_id]).to_f rescue 0
      valor = 0.0
      tratamentos = Tratamento.all(:conditions=>['dentista_id = ? and data between ? and ? and not excluido and clinica_id in (?)', self.id, inicio, fim, clinica_id])
      tratamentos.each do |trat|
        valor += trat.valor_com_desconto
      end
      self.percentual = 0 if self.percentual.nil?
      do_dentista     = (valor - custo ) * self.percentual / 100
    end
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
    resultado = Tratamento.do_dentista(id).por_data.entre(inicio, fim).da_clinica(clinicas).nao_excluido
  end
  
  def busca_producao_de_ortodontia(inicio,fim)
    em_dinheiro = Recebimento.all(:conditions =>["cheque_id IS NULL and data_de_exclusao IS NULL and (data between ? and ?) and paciente_id in (?)",inicio,fim,self.pacientes_de_ortodontia ],
                                 :select => 'data, paciente_id, valor, percentual_dentista, observacao') 
    em_cheque   = Recebimento.all(:joins => "INNER JOIN cheques ON cheques.id = recebimentos.cheque_id",
                                  :conditions =>["recebimentos.data_de_exclusao IS NULL and (recebimentos.data between ? and ?) and recebimentos.paciente_id in (?)",inicio,fim,self.pacientes_de_ortodontia ],
                                  :select => 'recebimentos.data, recebimentos.paciente_id, recebimentos.valor, percentual_dentista, observacao')
    em_dinheiro + em_cheque                            
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
    Paciente.all(:conditions => ["ortodontista_id = ?", self.id],
                 :order => :nome,
                 :select => 'nome, id, mensalidade_de_ortodontia,data_da_suspensao_da_cobranca_de_orto,motivo_suspensao_cobranca_orto')
  end

end
