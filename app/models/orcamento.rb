class Orcamento < ActiveRecord::Base
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

  def estado
    nao_feito = Tratamento.first(:conditions=>['orcamento_id = ? and data IS NULL', self.id])
    feito     = Tratamento.first(:conditions=>['orcamento_id = ? and data IS NOT NULL', self.id])
    return 'em aberto' if em_aberto?
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
  
  def self.proximo_numero(paciente_id)
    maior_codigo = Orcamento.do_paciente(paciente_id).ultimo_codigo.last
    if maior_codigo.nil?
      return 1
    else
      return maior_codigo.numero + 1
    end
  end

end
