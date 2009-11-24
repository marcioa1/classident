class Cheque < ActiveRecord::Base
  belongs_to :recebimento
  belongs_to :banco
  named_scope :por_bom_para, :order=>:bom_para
  named_scope :da_clinica, lambda{|clinica_id| {:conditions=>["clinica_id=?",clinica_id]}}

end
