class Paciente < ActiveRecord::Base
  belongs_to :tabela
  has_many :altas
  has_many :tratamentos
  has_many :debitos
  has_many :recebimentos
  has_many :trabalho_proteticos
  belongs_to :indicacao
  has_many :orcamentos
  belongs_to :ortodontista, :class_name=>"Dentista", :foreign_key=>'ortodontista_id'
  belongs_to :clinica
  belongs_to :dentista
  
  validates_presence_of :nome, :on => :create, :message => "Campo nome é obrigatório" 
  validates_presence_of :tabela, :on => :create, :message => "Tabela obrigatória"  
  validates_format_of :email, :with => /^(([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,}))?$/i, :only => [:create, :update], 
                         :message => 'Formato de email inválido.'
  
  named_scope :da_clinica, lambda{|clinica_id| {:conditions=>["clinica_id=?", clinica_id]}}
  named_scope :de_clinica, :conditions=>["ortodontia = ?", false]
  named_scope :de_ortodontia, :conditions=>["ortodontia = ?", true]
  named_scope :fora_da_lista_de_debito, :conditions=>["sair_da_lista_de_debitos = ? ", true]
  named_scope :fora_da_lista_de_debito_entre, lambda{|inicio,fim| {:conditions=>["sair_da_lista_de_debitos = ? 
    and data_da_saida_da_lista_de_debitos between ? and ?", true, inicio,fim]}}
  named_scope :por_nome, :order=>:nome
  
  #validates_uniqueness_of :codigo
  
  def extrato
    result = []
    recebimentos.each do |recebimento|
      result << recebimento unless recebimento.excluido?
    end
    result = (result + debitos).sort { |a,b| a.data<=>b.data }
  end
  
  
  def debito
    total = 0
    debitos.each() do |debito|
      total += debito.valor 
    end
    return total
  end
  
  def credito
    total = 0
    recebimentos.each() do |recebimento|
      total += recebimento.valor unless recebimento.excluido?
    end
    return total
  end
  
  def saldo
    credito-debito
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
  
  def verifica_alta_automatica(user,clinica)
    if !em_alta?
      if Tratamento.do_paciente(self.id).nao_feito.empty?
        alta = Alta.new
        alta.paciente_id = self.id
        alta.data_inicio = Date.today
        alta.observacao = "Alta automática"
        alta.user_id = user
        alta.clinica_id = clinica
        alta.save
        self.altas << alta
      end
    end
  end

end
