class Debito < ActiveRecord::Base
  acts_as_audited
  belongs_to :paciente
  
  validates_presence_of :valor, :only => [:create, :update], :message => "campo obrigatório"
  validates_presence_of :descricao, :only => [:create, :update], :message => "campo obrigatório"
  validates_numericality_of :valor, :greater_or_equal_than => 0,  :message => " deve ser numérico e maior do que zero."
  validate :verifica_quinzena
  #FIXME retirar em producao
  
  attr_accessor :data_br
  
  def data_br
    self.data = Date.today if self.data.nil?
    self.data.to_s_br
  end
  
  def data_br=(data)
    self.data = data.to_date if Date.valid?(data)
  end
  
  def self.cria_debitos_do_orcamento(orcamento_id)
    orcamento = Orcamento.find(orcamento_id)
    (1..orcamento.numero_de_parcelas).each do |par|
      deb             = Debito.new
      deb.paciente_id = orcamento.paciente_id
      deb.data        = orcamento.vencimento_primeira_parcela + (par - 1).month
      deb.valor       = orcamento.valor_da_parcela
      deb.descricao   = "ref orçamento " + orcamento.numero.to_s + " parcela " + par.to_s + " / " + orcamento.numero_de_parcelas.to_s
      deb.save
    end
  end

  def excluido?
    self.data_de_exclusao.present?
  end 
  
  def pode_excluir?
    self.tratamento_id.nil?
  end
  
  def pode_alterar?
    self.na_quinzena? 
  end
  
  def na_quinzena?
    primeira = Date.new(Date.today.year,Date.today.month,1)
    segunda  = Date.new(Date.today.year,Date.today.month,16)
    return false if self.data < primeira
    return false if self.data < segunda && Date.today >= segunda
    return true if self.data < segunda && Date.today < segunda
    return true if self.data >= segunda && Date.today >= segunda
    return true
  end
  
  def verifica_quinzena
    errors.add(:data, 'Fora da quinzena') if !na_quinzena?
  end
  
  def self.verifica_debitos_de_ortodontia(clinica_id)
    if MensalidadeOrtodontia.mudou_de_mes(clinica_id)
      pacientes = Paciente.da_clinica(clinica_id).cobranca_de_ortodontia_ativa
      pacientes.each do |paciente|
        Debito.create (:paciente_id => paciente.id, 
                       :valor       => paciente.mensalidade_de_ortodontia,
                       :descricao   => "mensalidade orto #{Date.today.month} / #{Date.today.year}",
                       :clinica_id  => clinica_id,
                       :data        => Date.today)
      end
      MensalidadeOrtodontia.registra_novo_mes(clinica_id)
    end
  end
  
end
