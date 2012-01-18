class Paciente < ActiveRecord::Base
  acts_as_audited
  
  cattr_reader :per_page
  @@per_page = 16
  
  belongs_to :tabela
  has_many :altas
  has_many :tratamentos
  has_many :debitos
  has_many :recebimentos
  has_many :trabalho_proteticos
  belongs_to :indicacao
  has_many :orcamentos
  has_many :abonos
  belongs_to :ortodontista, :class_name=>"Dentista", :foreign_key=>'ortodontista_id'
  belongs_to :clinica
  belongs_to :dentista
  
  validates_presence_of :nome, :on => :create, :message => "Campo nome é obrigatório" 
  validates_presence_of :tabela, :on => :create, :message => "Tabela obrigatória"  
  validates_presence_of :email
  # validates_format_of :email, :with => /^(([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,}))?$/i, :only => [:create, :update], 
  #                        :message => 'Formato de email inválido.'
  validates_presence_of :inicio_tratamento, :only => [:create, :update], :message => "A data de início do tratamento é obrigatória."
  #validates_format_of :inicio_tratamento, :with => /^[\w\d]+$/, :on => :create, :message => "is invalid"
 validates_length_of :cep, :maximum => 9
  after_create :verifica_debito_de_ortodontia
 
  named_scope :cobranca_de_ortodontia_ativa, :conditions =>["data_da_suspensao_da_cobranca_de_orto IS NULL and ortodontia = TRUE"]
  named_scope :da_clinica, lambda{|clinica_id| {:conditions=>["pacientes.clinica_id=?", clinica_id]}}
  named_scope :da_classident, :conditions=>["clinica_id < 8"]
  named_scope :de_clinica, :conditions=>["ortodontia = ?", false]
  named_scope :de_ortodontia, :conditions=>["ortodontia = ?", true]
  named_scope :fora_da_lista_de_debito, :conditions=>["sair_da_lista_de_debitos = ? ", true]
  named_scope :fora_da_lista_de_debito_entre, lambda{|inicio,fim| {:conditions=>["sair_da_lista_de_debitos = ? 
    and data_da_saida_da_lista_de_debitos between ? and ?", true, inicio,fim]}}
  named_scope :no_arquivo_morto, :conditions => ['arquivo_morto = ? ', true]
  named_scope :por_nome, :order=>:nome
  named_scope :recentes, 
              :joins => :recebimentos,
              # :limit => 5,
              :conditions=>(['recebimentos.data > ? AND recebimentos.data_de_exclusao IS NULL ', Date.today - 5.years]),
              :select => 'pacientes.id, pacientes.nome, pacientes.email, pacientes.logradouro, pacientes.numero, pacientes.complemento, pacientes.bairro, pacientes.cidade, pacientes.cep, pacientes.uf, recebimentos.data',
              :group => 'pacientes.id'
  named_scope :com_endereco_completo, :conditions=>["cep IS NOT NULL"]
  named_scope :com_logradouro, :conditions=>['logradouro IS NOT NULL']
  
  attr_accessor :inicio_tratamento_br, :data_suspensao_da_cobranca_de_orto_br,
                :data_da_saida_da_lista_de_debitos_br, :mensalidade_de_ortodontia_br
  attr_reader :termino_tratamento
  
  def termino_tratamento
    return "__/__/____" if altas.blank?
    ultima = altas.last(:order=>:created_at)
    ultima.data_termino.present? ? ultima.data_termino.to_s_br : "__/__/____"
  end

  def mensalidade_de_ortodontia_br
    self.mensalidade_de_ortodontia.real.to_s
  end
  def mensalidade_de_ortodontia_br=(value)
    self.mensalidade_de_ortodontia = value.gsub(".", '').gsub(',','.') rescue 0
  end
  
  def inicio_tratamento_br
    self.inicio_tratamento.nil? ? Date.today.to_s_br : self.inicio_tratamento.to_s_br
  end
  def inicio_tratamento_br=(value)
    self.inicio_tratamento = value.to_date if Date.valid?(value)
  end
  
  def data_suspensao_da_cobranca_de_orto_br
    self.data_suspensao_da_cobranca_de_orto_br = data_suspensao_da_cobranca_de_orto.to_s_br if data_suspensao_da_cobranca_de_orto_br
  end
  
  def data_suspensao_da_cobranca_de_orto_br=(data)
    self.data_suspensao_da_cobranca_de_orto = data_suspensao_da_cobranca_de_orto_br.to_date if Date.valid?(data_suspensao_da_cobranca_de_orto_br)
  end
  
  def data_da_saida_da_lista_de_debitos_br
    self.data_da_saida_da_lista_de_debitos.to_s_br if self.data_da_saida_da_lista_de_debitos
  end
  
  def data_da_saida_da_lista_de_debitos_br=(data)
    self.data_da_saida_da_lista_de_debitos = data_da_saida_da_lista_de_debitos_br.to_date if Date.valid?(data_da_saida_da_lista_de_debitos)
  end
  
  #validates_uniqueness_of :codigo
  
  def extrato
    result = []
    recebimentos.each do |recebimento|
      result << recebimento unless (recebimento.excluido? or (recebimento.em_cheque? && recebimento.cheque && recebimento.cheque.com_problema?))
    end
    result = (result + debitos_nao_excluidos + abonos).sort { |a,b| a.data<=>b.data }
  end
  
  def recebimentos_validos
    result = []
    recebimentos.each do |recebimento|
      result << recebimento unless (recebimento.excluido? or (recebimento.em_cheque? && recebimento.cheque && recebimento.cheque.com_problema?))
    end
    result
  end
  
  def total_de_debito
    total = 0
    debitos.each() do |debito|
      total += debito.valor unless debito.excluido? || debito.cancelado?
    end
    return total
  end
  
  def debitos_nao_excluidos
    self.debitos.find_all{|d| d.data_de_exclusao.nil?}
  end
  
  def total_de_credito
    total = 0
    recebimentos.each() do |recebimento|
      total += recebimento.valor unless recebimento.excluido?
    end
    return total
  end
  
  def total_de_abonos
    total = 0
    abonos.each() do |abono|
      total += abono.valor #unless abono.excluido?
    end
    return total
  end
  
  def saldo
    total_de_credito-total_de_debito+total_de_abonos
  end
  
  def gera_codigo(clinica_id)
    ultimo = Paciente.last(:conditions=>["clinica_id=?", clinica_id])
    if ultimo.nil?
      codigo = 0
    else
      codigo = ultimo.codigo
    end 
    return codigo + 1
  end
  
  
  def nome_e_clinica(administracao)
    if administracao
      clinica = Clinica.find(self.clinica_id)
      return nome + "   (#{clinica.nome})"
    else
      return nome
    end
  end
  
  def nome_corrigido
    result = ""
    nome.split(" ").each() do |parte|
      result += parte.capitalize + " "
    end
    result
  end
  
  def em_debito?
    saldo<0
  end
  
  def em_alta?
    return false if altas.blank?
    ultima = altas.last(:order=>:created_at)
    ultima.data_termino.nil?
  end
  
  def cheques_devolvidos
    devolvidos = []
    self.recebimentos.each do |recebimento|
      devolvidos << recebimento.cheque if recebimento.em_cheque? && recebimento.cheque && recebimento.cheque.com_problema?
    end
    devolvidos
  end

  def telefones
    result = ''
    result += self.telefone if self.telefone
    result += ' / '
    result += self.celular if self.celular
    result
  end
  
  def pendentes_protetico
    TrabalhoProtetico.pendentes.do_paciente(self.id)
  end
  
  def devolvidos_protetico
    TrabalhoProtetico.devolvidos.do_paciente(self.id) 
  end
  
  def recebimentos_excluidos
    Recebimento.all(:conditions=>['data_de_exclusao IS NOT NULL and paciente_id=?', self.id])
  end
  
  def self.busca_paciente(id)
    begin
      @paciente = Rails.cache.read(id)
      if !@paciente
        @paciente = Paciente.find(id)
        Rails.cache.write(@paciente.id.to_s, @paciente, :expires_in => 2.minutes) 
      end
    rescue
      @paciente = Paciente.find(id)
    end
    @paciente
  end

  def de_ortodontia?
    self.ortodontia
  end

  def verifica_debito_de_ortodontia
    if self.ortodontia?
      Debito.create(:paciente_id => self.id, 
                    :data        => Date.today, 
                    :valor       => self.mensalidade_de_ortodontia,
                    :descricao   => 'Primeira mensalidade de ortodontia',
                    :clinica_id  => self.clinica_id)
    end
  end
  
  def cheques
    result = []
    self.recebimentos.each do |rec|
      result << Cheque.find(rec.cheque_id) if rec.cheque
    end
    result
  end
  
  def rua
    self.logradouro + ' ' + self.numero + ', ' + self.complemento
  end
  
  def ultimo_lancamento
    rec = Recebimento.first(:select=>'data', :conditions=>['paciente_id = ? AND data_de_exclusao IS NULL', self.id], :order=>'data desc')
    deb = Debito.first(:select=>'data', :conditions=>['paciente_id = ? AND data_de_exclusao IS NULL', self.id], :order=>'data desc')
    if rec && deb
      if rec.data > deb.data
        rec.data
      else
        deb.data
      end
    elsif rec
      rec.data
    elsif deb
      deb.data
    else
      ''
    end
  end
  
end
