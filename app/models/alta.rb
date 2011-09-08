class Alta < ActiveRecord::Base
  acts_as_audited
  belongs_to :paciente
  belongs_to :user
  belongs_to :user_termino, :class_name => "User", :foreign_key => "user_termino_id"
  
  named_scope :em_alta, :conditions=>["data_termino IS NULL"]
  named_scope :da_clinica, lambda{|clinica_id| {:conditions=>['clinica_id = ?', clinica_id]}}
  named_scope :entre_datas, lambda{|inicio,fim| {:conditions=>['data_inicio between ? and ?', inicio, fim]}}
  named_scope :a_retornar, lambda{|mes,ano| {:conditions=>['MONTH(data_termino) = ? and YEAR(data_termino)=?', mes,ano]}}
end
