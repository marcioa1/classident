class Tratamento < ActiveRecord::Base
  belongs_to :paciente
  belongs_to :item_tabela
  belongs_to :dentista
  belongs_to :clinica
  
  named_scope :do_paciente, lambda{|paciente_id| {:conditions=>["paciente_id = ? and excluido=?", paciente_id,false]}}
  named_scope :do_dentista, lambda{|dentista_id| {:conditions=>["dentista_id = ? ", dentista_id]}}
  named_scope :nao_excluido, :conditions=>["excluido = ?",false]
  named_scope :por_data, :order=>:data
  named_scope :entre, lambda{|inicio,fim| {:conditions=>["data>=? and data <=?", inicio,fim]}}
  named_scope :da_clinica, lambda{|clinicas| {:conditions=>["clinica_id in (?)",clinicas]}}
  
  def valor_dentista
    (valor - custo) * dentista.percentual / 100 
  end
  
  def valor_clinica
    (valor - custo) * (100 - dentista.percentual) / 100 
  end
  
  def nao_pode_alterar?
    created_at < Date.today - 15.days
  end
  
  def finalizar_procedimento(user)
    debito = Debito.new
    debito.paciente_id = paciente_id
    debito.tratamento_id = id
    debito.descricao = item_tabela.descricao
    debito.valor = valor
    debito.data = data
    debito.save
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

end
