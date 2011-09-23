class Alta < ActiveRecord::Base
  acts_as_audited
  belongs_to :paciente
  belongs_to :user
  belongs_to :user_termino, :class_name => "User", :foreign_key => "user_termino_id"
  
  named_scope :em_alta, :conditions=>["data_termino IS NULL"]
  named_scope :da_clinica, lambda{|clinica_id| {:conditions=>['clinica_id = ?', clinica_id]}}
  named_scope :entre_datas, lambda{|inicio,fim| {:conditions=>['data_inicio between ? and ?', inicio, fim]}}
  named_scope :a_retornar, lambda{|mes,ano| {:conditions=>['MONTH(data_termino) = ? and YEAR(data_termino)=?', mes,ano]}}
  
  def self.verifica_alta_automatica(user, clinica, tratamento)
    if !tratamento.paciente.em_alta?
      if Tratamento.do_paciente(tratamento.paciente_id).nao_excluido.nao_feito.empty?
        alta             = Alta.new
        alta.paciente_id = tratamento.paciente_id.id
        alta.data_inicio = Date.today
        alta.observacao  = "Alta automática"
        alta.user_id     = user
        alta.clinica_id  = clinica
        if tratamento.item_tabela && tratamento.item_tabela.dias_de_retorno > 0
          alda.data_termino = Date.today + tratamento.item_tabela.dias_de_retorno.days
        else
          alta.data_termino = Date.today + 6.months
        end
        alta.save
        tratamento.paciente.altas << alta
      end
    end
  end
    
end
